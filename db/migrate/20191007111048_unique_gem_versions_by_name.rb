class UniqueGemVersionsByName < ActiveRecord::Migration[6.0]
  def up
    remove_index :gem_versions, [:name, :version]
    add_index :gem_versions, :name, unique: true
  end

  def down
    remove_index :gem_versions, :name
    add_index :gem_versions, [:name, :version], unique: true
  end
end
