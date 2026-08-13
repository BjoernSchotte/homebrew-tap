# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require_relative "../scripts/dev_release"

class DevReleaseTest < Minitest::Test
  SHA = "0123456789abcdef0123456789abcdef01234567"
  TAG = "dev-20260812.418.2-01234567"

  def test_stable_formula_declares_the_reciprocal_channel_conflict
    stable_formula = File.read(File.expand_path("../Formula/atlcli.rb", __dir__))
    assert_includes stable_formula, 'conflicts_with "atlcli-dev", because: "both formulae install the atlcli executable"'
  end

  def fixture(root, current: nil)
    FileUtils.mkdir_p(File.join(root, "Formula"))
    File.write(File.join(root, "Formula", "atlcli.rb"), "class Atlcli < Formula\nend\n")
    assets = File.join(root, "assets")
    FileUtils.mkdir_p(assets)
    extension = "atlcli-extension-chrome-mv3-#{TAG}.zip"
    payloads = AtlcliDevRelease::CLI_ARCHIVES + [extension]
    payloads.each { |name| File.binwrite(File.join(assets, name), "fixture #{name}\n") }
    eligibility = {
      "schema" => "atlcli.source-eligibility/v1", "decision" => "eligible", "sourceSha" => SHA,
      "workflow" => { "conclusion" => "success" }, "requiredJob" => { "conclusion" => "success" }
    }
    File.write(File.join(assets, "source-eligibility.json"), JSON.generate(eligibility))
    security = {
      "schema" => "atlcli.security-attestation/v1", "commit" => SHA,
      "veraPdfDigestOk" => true, "m1AcceptanceOk" => true, "checks" => []
    }
    File.write(File.join(assets, "security-attestation.json"), JSON.generate(security))
    artifact_records = (payloads + AtlcliDevRelease::DIGESTED_CONTROL_ASSETS).sort.map do |name|
      path = File.join(assets, name)
      { "name" => name, "size" => File.size(path), "sha256" => AtlcliDevRelease.sha256(path) }
    end
    metadata = {
      "schema" => "atlcli.build-metadata/v1", "channel" => "dev", "sourceSha" => SHA,
      "buildId" => TAG, "releaseTag" => TAG, "rootVersion" => "0.17.2",
      "run" => { "attempt" => 2, "createdAt" => "2026-08-12T15:32:45Z" },
      "sourceEligibilitySha256" => AtlcliDevRelease.sha256(File.join(assets, "source-eligibility.json")),
      "artifacts" => artifact_records
    }
    File.write(File.join(assets, "build-metadata.json"), JSON.generate(metadata))
    File.write(
      File.join(assets, "checksums.txt"),
      artifact_records.map { |record| "#{record.fetch("sha256")}  #{record.fetch("name")}" }.join("\n") + "\n"
    )
    names = payloads + AtlcliDevRelease::CONTROL_ASSETS
    release_assets = names.sort.map do |name|
      path = File.join(assets, name)
      { "name" => name, "size" => File.size(path), "digest" => "sha256:#{AtlcliDevRelease.sha256(path)}", "state" => "uploaded" }
    end
    release = {
      "tag_name" => TAG, "target_commitish" => SHA, "draft" => false, "prerelease" => true,
      "immutable" => true, "html_url" => "https://github.com/BjoernSchotte/atlcli/releases/tag/#{TAG}",
      "published_at" => "2026-08-12T16:00:00Z", "assets" => release_assets
    }
    File.write(File.join(root, "release.json"), JSON.generate(release))
    File.write(File.join(root, "tag-ref.json"), JSON.generate({ "object" => { "type" => "commit", "sha" => SHA } }))
    File.write(File.join(root, "current.json"), JSON.generate(current)) if current
    {
      release: File.join(root, "release.json"), tag_ref: File.join(root, "tag-ref.json"), assets: assets,
      tag: TAG, source_sha: SHA, source_repository: "BjoernSchotte/atlcli", request_id: "run-418",
      metadata_sha256: AtlcliDevRelease.sha256(File.join(assets, "build-metadata.json")),
      checksums_sha256: AtlcliDevRelease.sha256(File.join(assets, "checksums.txt")),
      current_pointer: current ? File.join(root, "current.json") : File.join(root, "missing.json"),
      output: File.join(root, "candidate"), repository_root: root, base_commit: "a" * 40
    }
  end

  def test_prepares_formula_and_pointer_from_exact_immutable_release
    Dir.mktmpdir do |root|
      receipt = AtlcliDevRelease.prepare(fixture(root))
      assert receipt.fetch("changed")
      formula = File.read(File.join(root, "candidate", "Formula", "atlcli-dev.rb"))
      assert_includes formula, "class AtlcliDev < Formula"
      assert_includes formula, "conflicts_with \"atlcli\""
      assert_includes formula, TAG
      assert_equal SHA, receipt.dig("pointer", "sourceSha")
      assert_equal "20260812153245.418.2", receipt.dig("pointer", "upstreamHomebrewVersion")
    end
  end

  def test_fails_closed_for_mutable_release_or_changed_asset
    Dir.mktmpdir do |root|
      options = fixture(root)
      release = AtlcliDevRelease.json(options[:release])
      release["immutable"] = false
      File.write(options[:release], JSON.generate(release))
      assert_raises(RuntimeError) { AtlcliDevRelease.prepare(options) }
    end
    Dir.mktmpdir do |root|
      options = fixture(root)
      File.binwrite(File.join(options[:assets], "atlcli-linux-x64.tar.gz"), "changed")
      assert_raises(RuntimeError) { AtlcliDevRelease.prepare(options) }
    end
  end

  def test_blocks_stale_candidate_without_exact_rollback_fence
    Dir.mktmpdir do |root|
      current = {
        "schema" => "atlcli.homebrew-dev-pointer/v1", "tag" => "dev-20260813.500.1-ffffffff",
        "sourceSha" => "f" * 40, "metadataSha256" => "a" * 64, "checksumsSha256" => "b" * 64,
        "formulaVersion" => "20260813120000.500.1", "upstreamHomebrewVersion" => "20260813120000.500.1"
      }
      options = fixture(root, current: current)
      assert_raises(RuntimeError) { AtlcliDevRelease.prepare(options) }
      options[:rollback_from_tag] = current["tag"]
      receipt = AtlcliDevRelease.prepare(options)
      assert_equal "20260813120000.500.2", receipt.dig("pointer", "formulaVersion")
      assert_equal current["tag"], receipt.dig("pointer", "rollbackFromTag")
    end
  end

  def test_same_tag_is_only_an_exact_noop
    Dir.mktmpdir do |root|
      options = fixture(root)
      first = AtlcliDevRelease.prepare(options)
      current_path = File.join(root, "current.json")
      File.write(current_path, JSON.generate(first.fetch("pointer")))
      FileUtils.cp(
        File.join(root, "candidate", "Formula", "atlcli-dev.rb"),
        File.join(root, "Formula", "atlcli-dev.rb")
      )
      second = AtlcliDevRelease.prepare(options.merge(current_pointer: current_path))
      refute second.fetch("changed")
    end
  end
end
