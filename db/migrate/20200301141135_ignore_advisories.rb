class IgnoreAdvisories < ActiveRecord::Migration[6.0]
  def change
    create_table :ignore_advisories do |t|
      t.bigint :project_id, null: false
      t.string :advisory_id, null: false
      t.timestamps
      t.index [:project_id, :advisory_id]
    end
  end
end
