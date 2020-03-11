class CreateModels < ActiveRecord::Migration[5.1]
  create_table "users", force: true do |t|
    t.string "email", null: false
    t.string "firstname", null: false
    t.string "lastname", null: false

    t.timestamps
  end

  create_table "portunus_data_encryption_keys", force: true do |t|
    t.string "encrypted_key", null: false
    t.string "master_keyname", null: false
    t.string "encryptable_type", null: false
    t.integer "encryptable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "last_dek_rotation", precision: 6
    t.datetime "last_kek_rotation", precision: 6
    t.index(
      ["encryptable_id", "encryptable_type"],
      name: "portunus_dek_on_encryptable_id_and_encryptable_type",
      unique: true
    )
  end
end
