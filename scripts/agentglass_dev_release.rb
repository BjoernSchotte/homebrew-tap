# frozen_string_literal: true
# Validates an agentglass dev prerelease and renders Formula/agentglass-dev.rb + metadata/agentglass-dev.json.
# Used by .github/workflows/update-agentglass-dev.yml; tests: ruby test/agentglass_dev_release_test.rb
require "digest"
require "fileutils"
require "json"
require "optparse"

module AgentglassDevRelease
  class Error < StandardError; end

  SOURCE_REPOSITORY = "BjoernSchotte/agentglass"
  ARCHIVES = %w[agentglass-darwin-arm64.tar.gz agentglass-darwin-x64.tar.gz agentglass-linux-arm64.tar.gz agentglass-linux-x64.tar.gz].freeze
  TAG_RE = /\Adev-(\d{8})\.([1-9]\d*)\.([1-9]\d*)-([0-9a-f]{8})\z/
  SHA_RE = /\A[0-9a-f]{40}\z/
  DIGEST_RE = /\A[0-9a-f]{64}\z/

  module_function

  def check(cond, msg) = (raise Error, msg unless cond)
  def sha256(path) = Digest::SHA256.file(path).hexdigest
  def parts(v) = v.split(".").map(&:to_i)

  # formula version "<YYYYMMDD>.<run>.<attempt>": monotonic because the date leads
  def formula_version(tag) = TAG_RE.match(tag).captures.first(3).join(".")

  def prepare(release:, assets:, tag:, source_sha:, metadata_sha256:, checksums_sha256:, current:)
    m = TAG_RE.match(tag)
    check(m, "invalid dev tag #{tag.inspect}")
    check(source_sha.match?(SHA_RE), "invalid source sha")
    check(source_sha.start_with?(m[4]), "tag #{tag} does not name commit #{source_sha}")
    check(metadata_sha256.match?(DIGEST_RE) && checksums_sha256.match?(DIGEST_RE), "invalid digest input")
    check(release["tagName"] == tag, "release tag mismatch")
    check(release["isDraft"] == false, "release is still a draft")
    check(release["isPrerelease"] == true, "release is not a prerelease")
    meta_path = File.join(assets, "build-metadata.json")
    sums_path = File.join(assets, "SHA256SUMS")
    check(sha256(meta_path) == metadata_sha256, "build-metadata.json digest mismatch")
    check(sha256(sums_path) == checksums_sha256, "SHA256SUMS digest mismatch")
    meta = JSON.parse(File.read(meta_path))
    check(meta["schema"] == "agentglass.build-metadata/v1", "build metadata schema mismatch")
    check(meta["channel"] == "dev" && meta["tag"] == tag && meta["sourceSha"] == source_sha, "build metadata does not match this release")
    version = meta.fetch("version")
    check(version.match?(/\A\d+\.\d+\.\d+-dev\.#{m[1]}\.#{m[2]}\+#{m[4]}\z/), "build metadata version #{version.inspect} does not match #{tag}")
    sums = File.readlines(sums_path, chomp: true).to_h { |l| h, n = l.split(/\s+/, 2); [n.to_s.delete_prefix("*"), h] }
    check(sums.keys.sort == ARCHIVES.sort, "SHA256SUMS must list exactly the 4 archives")
    digests = ARCHIVES.to_h do |n|
      d = sha256(File.join(assets, n))
      check(d == sums[n], "checksum mismatch for #{n}")
      [n, d]
    end

    fv = formula_version(tag)
    if current
      return { action: :noop, formula_version: current["formulaVersion"] } if current["tag"] == tag
      check((parts(fv) <=> parts(current.fetch("formulaVersion"))) == 1, "#{tag} is older than the current #{current["tag"]}")
    end
    pointer = { "schema" => "agentglass.homebrew-dev-pointer/v1", "sourceRepository" => SOURCE_REPOSITORY, "tag" => tag,
                "sourceSha" => source_sha, "version" => version, "formulaVersion" => fv,
                "metadataSha256" => metadata_sha256, "checksumsSha256" => checksums_sha256, "archives" => digests }
    { action: :update, formula_version: fv, formula: formula(tag, fv, version, source_sha, digests), pointer: pointer }
  end

  def formula(tag, fv, version, source_sha, d)
    url = ->(p) { "https://github.com/#{SOURCE_REPOSITORY}/releases/download/#{tag}/agentglass-#{p}.tar.gz" }
    <<~RUBY
      require "json"

      class AgentglassDev < Formula
        desc "Development channel of agentglass (daily build of main)"
        homepage "https://github.com/#{SOURCE_REPOSITORY}"
        version "#{fv}"
        license "Apache-2.0"

        on_macos do
          on_arm do
            url "#{url.("darwin-arm64")}"
            sha256 "#{d.fetch("agentglass-darwin-arm64.tar.gz")}"
          end
          on_intel do
            url "#{url.("darwin-x64")}"
            sha256 "#{d.fetch("agentglass-darwin-x64.tar.gz")}"
          end
        end

        on_linux do
          on_arm do
            url "#{url.("linux-arm64")}"
            sha256 "#{d.fetch("agentglass-linux-arm64.tar.gz")}"
          end
          on_intel do
            url "#{url.("linux-x64")}"
            sha256 "#{d.fetch("agentglass-linux-x64.tar.gz")}"
          end
        end

        conflicts_with "agentglass", because: "both formulae install the agentglass executable"

        def install
          bin.install "agentglass"
        end

        test do
          info = JSON.parse(shell_output("\#{bin}/agentglass --version --json"))
          assert_equal "dev", info.fetch("channel")
          assert_equal "#{source_sha}", info.fetch("commit")
          assert_equal "#{version}", info.fetch("version")
        end
      end
    RUBY
  end

  def main(argv)
    o = {}
    OptionParser.new do |p|
      %w[release assets tag source-sha metadata-sha256 checksums-sha256 current-pointer repository-root].each { |k| p.on("--#{k} V") { |v| o[k.tr("-", "_").to_sym] = v } }
    end.parse!(argv)
    current = File.file?(o[:current_pointer].to_s) ? JSON.parse(File.read(o[:current_pointer])) : nil
    out = prepare(release: JSON.parse(File.read(o.fetch(:release))), assets: o.fetch(:assets), tag: o.fetch(:tag), source_sha: o.fetch(:source_sha),
                  metadata_sha256: o.fetch(:metadata_sha256), checksums_sha256: o.fetch(:checksums_sha256), current: current)
    root = o.fetch(:repository_root, Dir.pwd)
    if out[:action] == :update
      File.write(File.join(root, "Formula/agentglass-dev.rb"), out[:formula])
      FileUtils.mkdir_p(File.join(root, "metadata"))
      File.write(File.join(root, "metadata/agentglass-dev.json"), JSON.pretty_generate(out[:pointer]) + "\n")
    end
    puts "#{out[:action]} #{out[:formula_version]}"
  rescue Error => e
    warn "agentglass_dev_release: #{e.message}"
    exit 1
  end
end

AgentglassDevRelease.main(ARGV) if $PROGRAM_NAME == __FILE__
