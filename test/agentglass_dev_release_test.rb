# frozen_string_literal: true
# tests for scripts/agentglass_dev_release.rb: ruby test/agentglass_dev_release_test.rb
require "minitest/autorun"
require "json"
require "tmpdir"
require "digest"
require_relative "../scripts/agentglass_dev_release"

class AgentglassDevReleaseTest < Minitest::Test
  TAG = "dev-20261005.12.1-a1b2c3d4"
  SHA = "a1b2c3d4" + "0" * 32
  VERSION = "2026.10.1-dev.20261005.12+a1b2c3d4"

  def setup
    @dir = Dir.mktmpdir
    @assets = File.join(@dir, "assets")
    Dir.mkdir(@assets)
    AgentglassDevRelease::ARCHIVES.each { |n| File.write(File.join(@assets, n), "bin #{n}") }
    sums = AgentglassDevRelease::ARCHIVES.map { |n| "#{Digest::SHA256.file(File.join(@assets, n)).hexdigest}  #{n}" }.join("\n") + "\n"
    File.write(File.join(@assets, "SHA256SUMS"), sums)
    File.write(File.join(@assets, "build-metadata.json"), JSON.generate("schema" => "agentglass.build-metadata/v1", "version" => VERSION, "channel" => "dev", "tag" => TAG, "sourceSha" => SHA))
    @release = { "tagName" => TAG, "isDraft" => false, "isPrerelease" => true }
  end

  def teardown = FileUtils.rm_rf(@dir)

  def digest(name) = Digest::SHA256.file(File.join(@assets, name)).hexdigest

  def prepare(**over)
    AgentglassDevRelease.prepare(release: @release, assets: @assets, tag: TAG, source_sha: SHA,
                                 metadata_sha256: digest("build-metadata.json"), checksums_sha256: digest("SHA256SUMS"),
                                 current: nil, **over)
  end

  def test_renders_formula_and_pointer
    out = prepare
    assert_equal "20261005.12.1", out[:formula_version]
    assert_includes out[:formula], %(version "20261005.12.1")
    assert_includes out[:formula], "releases/download/#{TAG}/agentglass-darwin-arm64.tar.gz"
    assert_includes out[:formula], %(sha256 "#{digest("agentglass-linux-x64.tar.gz")}")
    assert_includes out[:formula], %(conflicts_with "agentglass")
    assert_includes out[:formula], %(assert_equal "#{VERSION}", info.fetch("version"))
    assert_equal TAG, out[:pointer]["tag"]
    assert_equal "agentglass.homebrew-dev-pointer/v1", out[:pointer]["schema"]
  end

  def test_rejects_bad_inputs
    assert_raises(AgentglassDevRelease::Error) { prepare(tag: "dev-2026100.1.1-a1b2c3d4") }
    assert_raises(AgentglassDevRelease::Error) { prepare(source_sha: "xyz") }
    assert_raises(AgentglassDevRelease::Error) { prepare(metadata_sha256: "0" * 64) }
    assert_raises(AgentglassDevRelease::Error) { prepare(checksums_sha256: "0" * 64) }
  end

  def test_rejects_draft_or_stable_release
    @release["isDraft"] = true
    assert_raises(AgentglassDevRelease::Error) { prepare }
    @release["isDraft"] = false
    @release["isPrerelease"] = false
    assert_raises(AgentglassDevRelease::Error) { prepare }
  end

  def test_rejects_tampered_archive
    File.write(File.join(@assets, "agentglass-linux-x64.tar.gz"), "tampered")
    assert_raises(AgentglassDevRelease::Error) { prepare }
  end

  def test_rejects_metadata_for_another_commit
    File.write(File.join(@assets, "build-metadata.json"), JSON.generate("schema" => "agentglass.build-metadata/v1", "version" => VERSION, "channel" => "dev", "tag" => TAG, "sourceSha" => "f" * 40))
    assert_raises(AgentglassDevRelease::Error) { prepare(metadata_sha256: digest("build-metadata.json")) }
  end

  def test_same_tag_is_a_noop_and_older_is_refused
    assert_equal :noop, prepare(current: { "tag" => TAG, "formulaVersion" => "20261005.12.1" })[:action]
    assert_raises(AgentglassDevRelease::Error) { prepare(current: { "tag" => "dev-20261006.1.1-bbbbbbbb", "formulaVersion" => "20261006.1.1" }) }
    assert_equal :update, prepare(current: { "tag" => "dev-20261004.9.1-cccccccc", "formulaVersion" => "20261004.9.1" })[:action]
  end
end
