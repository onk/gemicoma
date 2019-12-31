RSpec.describe GemVersion do
  describe ".import_specs" do
    subject { GemVersion.import_specs(@specs) }

    before {
      @specs = [
        ["a", Gem::Version.new("1.0.0"), "ruby"],
        ["a", Gem::Version.new("1.1.0"), "ruby"],
        ["a", Gem::Version.new("1.2.0"), "ruby"],
        ["b", Gem::Version.new("2.0.0"), "ruby"],
        ["b", Gem::Version.new("1.0.0"), "ruby"],
        ["c", Gem::Version.new("1.0.0"), "ruby"],
      ]
    }

    context "insert" do
      specify "gem_version is inserted correctly" do
        subject

        expect(GemVersion.find_by(name: "a").version).to eq "1.2.0"
        expect(GemVersion.find_by(name: "b").version).to eq "2.0.0"
        expect(GemVersion.find_by(name: "c").version).to eq "1.0.0"
      end
    end
    context "upsert" do
      before {
        GemVersion.create!(name: "a", version: "1.1.0")
        GemVersion.create!(name: "c", version: "1.0.0")
      }
      specify "gem_version is upserted correctly" do
        subject

        expect(GemVersion.find_by(name: "a").version).to eq "1.2.0"
        expect(GemVersion.find_by(name: "b").version).to eq "2.0.0"
        expect(GemVersion.find_by(name: "c").version).to eq "1.0.0"
      end
    end
  end
end
