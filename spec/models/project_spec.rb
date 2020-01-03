RSpec.describe Project do
  describe "#import_project_gem_versions" do
    subject { @project.import_project_gem_versions(@specs) }

    before {
      @project = Project.create!(name: "foo")

      @specs = [
        Bundler::LazySpecification.new("activemodel", Gem::Version.create("6.0.2.1"), "ruby"),
        Bundler::LazySpecification.new("activerecord", Gem::Version.create("6.0.2.1"), "ruby"),
        Bundler::LazySpecification.new("addressable", Gem::Version.create("2.7.0"), "ruby"),
      ]
    }

    context "insert" do
      specify "insert project_gem_versions is inserted correctly" do
        subject

        expect(GemVersion.count).to eq 3
        expect(@project.project_gem_versions.count).to eq 3

        gem_version_1 = GemVersion.find_by(name: "activemodel")
        pgv_1 = @project.project_gem_versions.find_by(gem_version_id: gem_version_1.id)
        expect(gem_version_1.version).to eq "6.0.2.1"
        expect(pgv_1.locked_version).to eq "6.0.2.1"

        gem_version_2 = GemVersion.find_by(name: "addressable")
        pgv_2 = @project.project_gem_versions.find_by(gem_version_id: gem_version_2.id)
        expect(gem_version_2.version).to eq "2.7.0"
        expect(pgv_2.locked_version).to eq "2.7.0"
      end
    end

    context "upsert" do
      before {
        @gem_version_1 = GemVersion.create!(name: "activemodel", version: "6.0.2")
        @gem_version_2 = GemVersion.create!(name: "addressable", version: "2.7.0")

        @pgv_1 = @project.project_gem_versions.create!(gem_version: @gem_version_1, locked_version: "6.0.0")
        @pgv_2 = @project.project_gem_versions.create!(gem_version: @gem_version_2, locked_version: "2.6.0")
      }

      specify "upsert project_gem_versions is upserted correctly" do
        subject

        # project_gem_version's locked_version is updated
        expect(GemVersion.count).to eq 3
        expect(@project.project_gem_versions.count).to eq 3
        expect(@pgv_1.reload.locked_version).to eq "6.0.2.1"
        expect(@pgv_2.reload.locked_version).to eq "2.7.0"

        # gem_version_3 is created
        gem_version_3 = GemVersion.where.not(id: [@gem_version_1.id, @gem_version_2.id]).first
        pgv_3 = @project.project_gem_versions.where(gem_version_id: gem_version_3.id).first
        expect(gem_version_3.name).to eq "activerecord"
        expect(gem_version_3.version).to eq "6.0.2.1"
        expect(pgv_3.locked_version).to eq "6.0.2.1"
      end
    end
  end
end
