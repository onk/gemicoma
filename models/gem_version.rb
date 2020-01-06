class GemVersion < ActiveRecord::Base
  has_many :project_gem_versions

  # specs is Marshal.load of specs.4.8.gz, an array of arrays.
  # [
  #   [gem_name, Gem::Version, platform],
  #   [gem_name, Gem::Version, platform],
  #   ...
  # ]
  def self.import_specs(specs)
    # convert to { name => latest_version } hash
    hash = specs.group_by(&:first).map {|gem_name, a_of_a| [gem_name, a_of_a.max_by {|a| a[1] }.second ] }.to_h

    all_gems_idx = GemVersion.all.index_by(&:name)

    now = Time.current
    gem_versions = []
    hash.each do |gem_name, latest_version|
      gem_version = all_gems_idx[gem_name] || GemVersion.new(name: gem_name)
      gem_version.version = latest_version.to_s
      if gem_version.changed?
        gem_version.created_at ||= now
        gem_version.updated_at = now
        gem_versions << gem_version.attributes
      end
    end
    GemVersion.upsert_all(gem_versions)
  end
end
