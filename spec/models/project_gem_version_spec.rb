RSpec.describe ProjectGemVersion do
  describe "#status" do
    subject { @project_gem_version.status }
    before {
      @gem_version = GemVersion.new(name: "foo", version: "2.5.0")
      @project_gem_version = ProjectGemVersion.new(gem_version: @gem_version, locked_version: locked_version)
    }

    context "outdated" do
      let(:locked_version) { "1.9.9" }
      it { is_expected.to eq ProjectGemVersion::Status::OUTDATED }
    end
    context "behind" do
      let(:locked_version) { "2.4.9" }
      it { is_expected.to eq ProjectGemVersion::Status::BEHIND }
    end
    context "latest" do
      let(:locked_version) { "2.5.0" }
      it { is_expected.to eq ProjectGemVersion::Status::LATEST }
    end
  end
end
