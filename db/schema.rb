# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define() do
  create_table "gem_versions", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "version", null: false
    t.index ["name"], name: "name", unique: true
  end

  create_table "ignore_advisories", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "advisory_id", null: false
    t.datetime "created_at", null: false
    t.bigint "project_id", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "advisory_id"], name: "project_id_and_advisory_id"
  end

  create_table "project_gem_versions", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "gem_version_id", null: false, unsigned: true
    t.string "locked_version", null: false
    t.bigint "project_id", null: false, unsigned: true
    t.string "specified_version"
    t.datetime "updated_at", null: false
    t.index ["gem_version_id"], name: "gem_version_id"
    t.index ["project_id", "gem_version_id"], name: "project_id_and_gem_version_id", unique: true
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.string "full_name", null: false
    t.boolean "is_active", default: true
    t.datetime "last_gemfile_lock_changed_at", precision: nil
    t.datetime "last_sync_at", precision: nil
    t.string "path", default: "", null: false
    t.string "site", null: false
    t.datetime "updated_at", null: false
    t.index ["site", "full_name", "path", "is_active"], name: "site_and_full_name_and_path_and_is_active", unique: true
  end

  create_table "user_accounts", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "provider", null: false
    t.text "raw_info"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, unsigned: true
    t.index ["provider", "uid"], name: "provider_and_uid", unique: true
    t.index ["user_id"], name: "user_id", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end
end
