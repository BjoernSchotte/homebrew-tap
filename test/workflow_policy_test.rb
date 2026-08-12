# frozen_string_literal: true

require "minitest/autorun"

class WorkflowPolicyTest < Minitest::Test
  def workflow
    @workflow ||= File.read(File.expand_path("../.github/workflows/update-dev-formula.yml", __dir__))
  end

  def test_keeps_default_permissions_read_only_and_writes_only_after_native_proof
    assert_match(/^permissions:\n  contents: read$/, workflow)
    assert_includes workflow, "needs: [prepare, verify-native]"
    assert_equal 1, workflow.scan("contents: write").length
    assert_includes workflow, "git add Formula/atlcli-dev.rb metadata/atlcli-dev.json"
    refute_includes workflow, "Formula/atlcli.rb metadata"
  end

  def test_uses_all_four_current_native_runner_classes
    {
      "linux-x64" => "ubuntu-24.04",
      "linux-arm64" => "ubuntu-24.04-arm",
      "darwin-x64" => "macos-15-intel",
      "darwin-arm64" => "macos-15"
    }.each do |target, runner|
      assert_includes workflow, "target: #{target}"
      assert_includes workflow, "runner: #{runner}"
    end
  end

  def test_validates_immutable_upstream_before_brew_and_guards_rollbacks
    assert_includes workflow, "scripts/dev_release.rb"
    assert_includes workflow, "release-assets/source-eligibility.json"
    assert_includes workflow, "--rollback-from-tag"
    assert_includes workflow, "brew audit --strict"
    assert_includes workflow, "brew tap-new atlcli-proof/tap"
    assert_includes workflow, "atlcli-proof/tap/atlcli-dev"
    assert_includes workflow, "conflict-verification.json"
    assert_includes workflow, "cancel-in-progress: false"
  end
end
