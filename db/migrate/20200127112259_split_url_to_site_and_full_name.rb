class SplitUrlToSiteAndFullName < ActiveRecord::Migration[6.0]
  def change
    change_table :projects do |t|
      t.remove_index :url_and_is_active
      t.rename :url, :site
      t.string :full_name, null: false, after: :site
      t.index [:site, :full_name, :is_active], unique: true
    end
  end
end
