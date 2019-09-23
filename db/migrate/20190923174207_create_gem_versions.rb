class CreateGemVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :gem_versions do |t|
      t.string :name,    null: false
      t.string :version, null: false
      t.timestamps

      t.index [:name, :version], unique: true
    end
  end
end
