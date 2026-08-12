#!/usr/bin/env ruby
# frozen_string_literal: true

require "digest"
require "fileutils"
require "json"
require "optparse"
require "rbconfig"
require "shellwords"

module AtlcliDevRelease
  SOURCE_REPOSITORY = "BjoernSchotte/atlcli"
  TAG_PATTERN = /\Adev-(\d{8})\.(\d+)\.(\d+)-([0-9a-f]{8})\z/
  SHA_PATTERN = /\A[0-9a-f]{40}\z/
  SHA256_PATTERN = /\A[0-9a-f]{64}\z/
  CLI_ARCHIVES = %w[
    atlcli-darwin-arm64.tar.gz
    atlcli-darwin-x64.tar.gz
    atlcli-linux-arm64.tar.gz
    atlcli-linux-x64.tar.gz
    atlcli-windows-x64.zip
  ].freeze
  BREW_ARCHIVES = (CLI_ARCHIVES - ["atlcli-windows-x64.zip"]).freeze
  CONTROL_ASSETS = %w[
    build-metadata.json
    checksums.txt
    security-attestation.json
    source-eligibility.json
  ].freeze

  module_function

  def sha256(path)
    Digest::SHA256.file(path).hexdigest
  end

  def json(path)
    JSON.parse(File.read(path, encoding: "UTF-8"))
  rescue JSON::ParserError => e
    raise "invalid JSON in #{path}: #{e.message}"
  end

  def assert(condition, message)
    raise message unless condition
  end

  def version_parts(value)
    assert(value.is_a?(String) && value.match?(/\A\d+(?:\.\d+)*\z/), "invalid numeric formula version")
    value.split(".").map(&:to_i)
  end

  def compare_versions(left, right)
    length = [left.length, right.length].max
    (0...length).each do |index|
      comparison = (left[index] || 0) <=> (right[index] || 0)
      return comparison unless comparison.zero?
    end
    0
  end

  def bump_version(value)
    parts = version_parts(value)
    parts[-1] += 1
    parts.join(".")
  end

  def parse_checksums(path)
    records = {}
    File.readlines(path, chomp: true).each do |line|
      match = /\A([0-9a-f]{64})  ([A-Za-z0-9][A-Za-z0-9._-]*)\z/.match(line)
      assert(match, "invalid checksums.txt line")
      assert(!records.key?(match[2]), "duplicate checksums.txt entry")
      records[match[2]] = match[1]
    end
    records
  end

  def release_asset_map(release)
    assets = release.fetch("assets")
    assert(assets.is_a?(Array), "release assets must be an array")
    result = {}
    assets.each do |asset|
      name = asset.fetch("name")
      assert(!result.key?(name), "duplicate GitHub release asset")
      result[name] = asset
    end
    result
  end

  def validate_release!(release:, tag_ref:, assets_dir:, tag:, source_sha:, metadata_sha256:, checksums_sha256:)
    tag_match = TAG_PATTERN.match(tag)
    assert(tag_match, "invalid dev tag")
    assert(source_sha.match?(SHA_PATTERN), "invalid source SHA")
    assert(tag_match[4] == source_sha[0, 8], "tag short SHA does not match source SHA")
    assert(release["tag_name"] == tag, "release tag mismatch")
    assert(release["target_commitish"] == source_sha, "release target SHA mismatch")
    assert(release["draft"] == false, "release is still a draft")
    assert(release["prerelease"] == true, "release is not a prerelease")
    assert(release["immutable"] == true, "release is not immutable")
    assert(tag_ref.dig("object", "type") == "commit", "dev tag must point directly to a commit")
    assert(tag_ref.dig("object", "sha") == source_sha, "dev tag ref source mismatch")

    metadata_path = File.join(assets_dir, "build-metadata.json")
    checksums_path = File.join(assets_dir, "checksums.txt")
    assert(sha256(metadata_path) == metadata_sha256, "build metadata input digest mismatch")
    assert(sha256(checksums_path) == checksums_sha256, "checksums input digest mismatch")
    metadata = json(metadata_path)
    eligibility = json(File.join(assets_dir, "source-eligibility.json"))
    security = json(File.join(assets_dir, "security-attestation.json"))

    assert(metadata["schema"] == "atlcli.build-metadata/v1", "build metadata schema mismatch")
    assert(metadata["channel"] == "dev", "build metadata channel mismatch")
    assert(metadata["sourceSha"] == source_sha, "build metadata source mismatch")
    assert(metadata["buildId"] == tag && metadata["releaseTag"] == tag, "build metadata tag mismatch")
    assert(metadata.dig("run", "attempt") == tag_match[3].to_i, "build metadata attempt mismatch")
    assert(metadata.dig("run", "createdAt").to_s[0, 10].delete("-") == tag_match[1], "build date mismatch")
    created_second = metadata.dig("run", "createdAt").to_s[0, 19].delete("-:T")
    assert(created_second.match?(/\A\d{14}\z/), "build creation time cannot derive a Homebrew version")
    homebrew_version = "#{created_second}.#{tag_match[2]}.#{tag_match[3]}"
    version_parts(homebrew_version)

    assert(security["schema"] == "atlcli.security-attestation/v1", "security schema mismatch")
    assert(security["commit"] == source_sha, "security attestation source mismatch")
    assert(security["veraPdfDigestOk"] != false && security["m1AcceptanceOk"] != false, "security gate failed")
    assert(Array(security["checks"]).none? { |check| check["status"] == "failed" }, "security check failed")

    assert(eligibility["schema"] == "atlcli.source-eligibility/v1", "eligibility schema mismatch")
    assert(eligibility["decision"] == "eligible", "source is not eligible")
    assert(eligibility["sourceSha"] == source_sha, "eligibility source mismatch")
    assert(eligibility.dig("workflow", "conclusion") == "success", "source workflow was not green")
    assert(eligibility.dig("requiredJob", "conclusion") == "success", "required source job was not green")
    assert(metadata["sourceEligibilitySha256"] == sha256(File.join(assets_dir, "source-eligibility.json")), "eligibility digest mismatch")

    extension_name = "atlcli-extension-chrome-mv3-#{tag}.zip"
    payload_names = (CLI_ARCHIVES + [extension_name]).sort
    metadata_artifacts = Array(metadata["artifacts"])
    assert(metadata_artifacts.map { |asset| asset["name"] }.sort == payload_names, "metadata artifact inventory mismatch")
    checksum_records = parse_checksums(checksums_path)
    assert(checksum_records.keys.sort == payload_names, "checksum artifact inventory mismatch")
    expected_release_names = (payload_names + CONTROL_ASSETS).sort
    release_assets = release_asset_map(release)
    assert(release_assets.keys.sort == expected_release_names, "GitHub release asset inventory mismatch")
    local_names = Dir.children(assets_dir).select { |name| File.file?(File.join(assets_dir, name)) }.sort
    assert(local_names == expected_release_names, "downloaded release asset inventory mismatch")

    metadata_artifacts.each do |record|
      name = record.fetch("name")
      path = File.join(assets_dir, name)
      digest = sha256(path)
      assert(record["sha256"] == digest, "metadata digest mismatch for #{name}")
      assert(record["size"] == File.size(path), "metadata size mismatch for #{name}")
      assert(checksum_records[name] == digest, "checksums.txt mismatch for #{name}")
    end
    release_assets.each do |name, record|
      path = File.join(assets_dir, name)
      assert(record["state"] == "uploaded", "release asset is incomplete: #{name}")
      assert(record["size"] == File.size(path), "release asset size mismatch: #{name}")
      assert(record["digest"] == "sha256:#{sha256(path)}", "release server digest mismatch: #{name}")
    end
    [metadata, extension_name, homebrew_version]
  end

  def formula(homebrew_version:, tag:, source_sha:, formula_version:, archive_digests:)
    <<~RUBY
      require "json"

      class AtlcliDev < Formula
        desc "Development channel for the Atlassian Confluence and Jira CLI"
        homepage "https://atlcli.sh"
        version "#{formula_version}"
        license "MIT"

        on_macos do
          on_arm do
            url "https://github.com/BjoernSchotte/atlcli/releases/download/#{tag}/atlcli-darwin-arm64.tar.gz"
            sha256 "#{archive_digests.fetch("atlcli-darwin-arm64.tar.gz")}"
          end
          on_intel do
            url "https://github.com/BjoernSchotte/atlcli/releases/download/#{tag}/atlcli-darwin-x64.tar.gz"
            sha256 "#{archive_digests.fetch("atlcli-darwin-x64.tar.gz")}"
          end
        end

        on_linux do
          on_arm do
            url "https://github.com/BjoernSchotte/atlcli/releases/download/#{tag}/atlcli-linux-arm64.tar.gz"
            sha256 "#{archive_digests.fetch("atlcli-linux-arm64.tar.gz")}"
          end
          on_intel do
            url "https://github.com/BjoernSchotte/atlcli/releases/download/#{tag}/atlcli-linux-x64.tar.gz"
            sha256 "#{archive_digests.fetch("atlcli-linux-x64.tar.gz")}"
          end
        end

        conflicts_with "atlcli", because: "both formulae install the atlcli executable"

        def install
          bin.install "atlcli"
        end

        test do
          info = JSON.parse(shell_output("\#{bin}/atlcli release-info --json --no-log"))
          assert_equal "dev", info.fetch("channel")
          assert_equal "#{tag}", info.fetch("releaseTag")
          assert_equal "#{source_sha}", info.fetch("sourceSha")
          assert_equal "#{homebrew_version}", info.fetch("homebrewVersion")
        end
      end
    RUBY
  end

  def prepare(options)
    assert(options.fetch(:source_repository) == SOURCE_REPOSITORY, "source repository is not allowlisted")
    assert(options.fetch(:request_id).match?(/\A[A-Za-z0-9][A-Za-z0-9._-]{0,127}\z/), "invalid request ID")
    release = json(options.fetch(:release))
    tag_ref = json(options.fetch(:tag_ref))
    metadata, extension_name, upstream_version = validate_release!(
      release: release,
      tag_ref: tag_ref,
      assets_dir: options.fetch(:assets),
      tag: options.fetch(:tag),
      source_sha: options.fetch(:source_sha),
      metadata_sha256: options.fetch(:metadata_sha256),
      checksums_sha256: options.fetch(:checksums_sha256)
    )
    repository_root = options.fetch(:repository_root, Dir.pwd)
    current = File.file?(options.fetch(:current_pointer)) ? json(options.fetch(:current_pointer)) : nil
    same_current_release = false
    if current
      assert(current["schema"] == "atlcli.homebrew-dev-pointer/v1", "current pointer schema mismatch")
      if current["tag"] == options.fetch(:tag)
        same = current["sourceSha"] == options.fetch(:source_sha) &&
               current["metadataSha256"] == options.fetch(:metadata_sha256) &&
               current["checksumsSha256"] == options.fetch(:checksums_sha256)
        assert(same, "existing Homebrew tag points to different release identity")
        same_current_release = true
      elsif compare_versions(version_parts(upstream_version), version_parts(current.fetch("upstreamHomebrewVersion"))) <= 0
        assert(options[:rollback_from_tag] == current["tag"], "superseded candidate cannot replace the current dev formula")
      end
    end
    formula_version = if current && current["tag"] == options.fetch(:tag)
                        current.fetch("formulaVersion")
                      elsif current && compare_versions(version_parts(upstream_version), version_parts(current.fetch("formulaVersion"))) <= 0
                        bump_version(current.fetch("formulaVersion"))
                      else
                        upstream_version
                      end
    archive_digests = BREW_ARCHIVES.to_h { |name| [name, sha256(File.join(options.fetch(:assets), name))] }
    pointer = {
      "schema" => "atlcli.homebrew-dev-pointer/v1",
      "sourceRepository" => SOURCE_REPOSITORY,
      "tag" => options.fetch(:tag),
      "sourceSha" => options.fetch(:source_sha),
      "formulaVersion" => formula_version,
      "upstreamHomebrewVersion" => upstream_version,
      "metadataSha256" => options.fetch(:metadata_sha256),
      "checksumsSha256" => options.fetch(:checksums_sha256),
      "requestId" => same_current_release ? current.fetch("requestId") : options.fetch(:request_id),
      "releaseUrl" => release.fetch("html_url"),
      "releasePublishedAt" => release.fetch("published_at"),
      "rollbackFromTag" => same_current_release ? current["rollbackFromTag"] : options[:rollback_from_tag],
      "archives" => archive_digests.sort.to_h
    }
    output = options.fetch(:output)
    FileUtils.rm_rf(output)
    FileUtils.mkdir_p(File.join(output, "Formula"))
    FileUtils.mkdir_p(File.join(output, "metadata"))
    File.write(
      File.join(output, "Formula", "atlcli-dev.rb"),
      formula(
        homebrew_version: upstream_version,
        tag: options.fetch(:tag),
        source_sha: options.fetch(:source_sha),
        formula_version: formula_version,
        archive_digests: archive_digests
      )
    )
    File.write(File.join(output, "metadata", "atlcli-dev.json"), "#{JSON.pretty_generate(pointer)}\n")
    current_formula = File.join(repository_root, "Formula", "atlcli-dev.rb")
    stable_formula = File.join(repository_root, "Formula", "atlcli.rb")
    changed = !current || current != pointer || !File.file?(current_formula) ||
              File.read(current_formula) != File.read(File.join(output, "Formula", "atlcli-dev.rb"))
    receipt = {
      "schema" => "atlcli.homebrew-dev-prepare/v1",
      "changed" => changed,
      "stableFormulaSha256" => sha256(stable_formula),
      "baseCommit" => options[:base_commit] || `git -C #{repository_root.shellescape} rev-parse HEAD`.strip,
      "pointer" => pointer
    }
    File.write(File.join(output, "prepare-receipt.json"), "#{JSON.pretty_generate(receipt)}\n")
    receipt
  end

  def verify_installed(options)
    pointer = json(options.fetch(:pointer))
    info = json(options.fetch(:release_info))
    target = options.fetch(:target)
    runtime = {
      "darwin-arm64" => ["darwin", /arm64|aarch64/],
      "darwin-x64" => ["darwin", /x86_64|x64/],
      "linux-arm64" => ["linux", /arm64|aarch64/],
      "linux-x64" => ["linux", /x86_64|x64/]
    }.fetch(target)
    assert(RUBY_PLATFORM.include?(runtime[0]), "formula was not tested on the target operating system")
    assert(RbConfig::CONFIG.fetch("host_cpu").match?(runtime[1]), "formula was not tested on the target architecture")
    assert(info["schema"] == "atlcli.release-info/v1", "installed CLI schema mismatch")
    assert(info["channel"] == "dev", "installed CLI is not a dev build")
    assert(info["releaseTag"] == pointer["tag"], "installed CLI tag mismatch")
    assert(info["sourceSha"] == pointer["sourceSha"], "installed CLI source mismatch")
    assert(info["homebrewVersion"] == pointer["upstreamHomebrewVersion"], "installed CLI Homebrew identity mismatch")
    {
      "schema" => "atlcli.homebrew-dev-native-verification/v1",
      "target" => target,
      "rubyPlatform" => RUBY_PLATFORM,
      "hostCpu" => RbConfig::CONFIG.fetch("host_cpu"),
      "releaseInfo" => info
    }
  end
end

if $PROGRAM_NAME == __FILE__
  command = ARGV.shift
  options = {}
  OptionParser.new do |parser|
    %i[release tag_ref assets tag source_sha source_repository request_id metadata_sha256 checksums_sha256 current_pointer rollback_from_tag output pointer release_info target receipt repository_root base_commit].each do |name|
      parser.on("--#{name.to_s.tr("_", "-")} VALUE") { |value| options[name] = value }
    end
  end.parse!(ARGV)
  result = case command
           when "prepare" then AtlcliDevRelease.prepare(options)
           when "verify-installed" then AtlcliDevRelease.verify_installed(options)
           else raise "command must be prepare or verify-installed"
           end
  rendered = "#{JSON.pretty_generate(result)}\n"
  File.write(options[:receipt], rendered) if options[:receipt]
  puts rendered
end
