# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180628171309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "annotations", force: :cascade do |t|
    t.integer  "text_id"
    t.integer  "sentence"
    t.string   "ip"
    t.integer  "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "annotations", ["text_id"], name: "index_annotations_on_text_id", using: :btree

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.string "institution"
  end

  create_table "authors_texts", id: false, force: :cascade do |t|
    t.integer "text_id",               null: false
    t.integer "author_id",             null: false
    t.integer "sorting",   default: 0
  end

  create_table "chapters", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "part_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "text_id"
    t.text     "body"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "author_name"
    t.string   "author_email"
    t.integer  "sentence_checksum"
  end

  create_table "editions", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "sorting"
  end

  create_table "keywords", force: :cascade do |t|
    t.string   "word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "sentence"
    t.integer  "text_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "sorting"
    t.integer  "edition_id"
  end

  add_index "parts", ["edition_id"], name: "index_parts_on_edition_id", using: :btree

  create_table "sentences", force: :cascade do |t|
    t.text     "body"
    t.integer  "text_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "checksum"
    t.integer  "position"
    t.boolean  "excluded_from_export", default: false
    t.text     "body_text",            default: "",    null: false
  end

  add_index "sentences", ["excluded_from_export"], name: "index_sentences_on_excluded_from_export", using: :btree
  add_index "sentences", ["text_id", "position"], name: "index_sentences_on_text_id_and_position", unique: true, where: "(\"position\" IS NOT NULL)", using: :btree

  create_table "texts", force: :cascade do |t|
    t.text     "body"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "title"
    t.text     "abstract"
    t.text     "notes"
    t.text     "bibliography"
    t.string   "source_file"
    t.integer  "part_id"
    t.integer  "edition_id"
    t.integer  "sorting"
    t.boolean  "is_static"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "alias"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "parts", "editions"

  create_view "user_ip_mappings", materialized: true,  sql_definition: <<-SQL
      WITH current_ips AS (
           SELECT DISTINCT ON (users.current_sign_in_ip) first_value(users.id) OVER w AS user_id,
              users.current_sign_in_ip AS ip_address
             FROM users
            WINDOW w AS (PARTITION BY users.current_sign_in_ip ORDER BY users.current_sign_in_at DESC NULLS LAST)
          ), last_ips AS (
           SELECT DISTINCT ON (users.last_sign_in_ip) first_value(users.id) OVER w AS user_id,
              users.last_sign_in_ip AS ip_address
             FROM users
            WHERE ((NOT (users.id IN ( SELECT current_ips.user_id
                     FROM current_ips))) AND (NOT ((users.last_sign_in_ip)::text IN ( SELECT current_ips.ip_address
                     FROM current_ips))))
            WINDOW w AS (PARTITION BY users.last_sign_in_ip ORDER BY users.last_sign_in_at DESC NULLS LAST)
          )
   SELECT current_ips.user_id,
      current_ips.ip_address
     FROM current_ips
  UNION ALL
   SELECT last_ips.user_id,
      last_ips.ip_address
     FROM last_ips;
  SQL

  add_index "user_ip_mappings", ["ip_address"], name: "index_user_ip_mappings_on_ip_address", unique: true, using: :btree
  add_index "user_ip_mappings", ["user_id"], name: "index_user_ip_mappings_on_user_id", unique: true, using: :btree

  create_view "sentence_mappings", materialized: true,  sql_definition: <<-SQL
      WITH exportable_comment_checksums AS (
           SELECT comments.sentence_checksum AS checksum,
              count(*) AS comments_count
             FROM comments
            WHERE ((NOT (comments.id IN ( SELECT comments_1.id
                     FROM comments comments_1
                    WHERE (NOT (comments_1.sentence_checksum IN ( SELECT DISTINCT sentences.checksum
                             FROM sentences)))))) AND (NOT (comments.id IN ( SELECT comments_1.id
                     FROM comments comments_1
                    WHERE ((comments_1.body !~~* '% %'::text) AND (NOT ((comments_1.body ~~* '%.%'::text) OR (comments_1.body ~~* '%?%'::text) OR (comments_1.body ~~* '%!%'::text))) AND (comments_1.user_id IS NULL) AND (NOT (comments_1.id IN ( SELECT comments_2.parent_id
                             FROM comments comments_2
                            WHERE (comments_2.parent_id IS NOT NULL)))) AND (comments_1.parent_id IS NULL))))))
            GROUP BY comments.sentence_checksum
          ), exportable_annotation_checksums AS (
           SELECT annotations.sentence AS checksum,
              count(*) AS annotations_count
             FROM annotations
            WHERE ((annotations.ip)::text IN ( SELECT DISTINCT user_ip_mappings.ip_address
                     FROM user_ip_mappings))
            GROUP BY annotations.sentence
          ), exportable_checksums AS (
           SELECT exportable_comment_checksums.checksum
             FROM exportable_comment_checksums
          UNION
           SELECT exportable_annotation_checksums.checksum
             FROM exportable_annotation_checksums
          )
   SELECT s.id AS sentence_id,
      s.text_id,
      t.edition_id,
      s.checksum,
      string_agg(s.body_text, ' '::text) OVER (PARTITION BY s.text_id ORDER BY s."position" ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS previous_text,
      lag(s.body_text) OVER w AS previous_body,
      s.body_text AS body,
      lead(s.body_text) OVER w AS next_body,
      string_agg(s.body_text, ' '::text) OVER (PARTITION BY s.text_id ORDER BY s."position" ROWS BETWEEN 1 FOLLOWING AND UNBOUNDED FOLLOWING) AS next_text,
      (s.checksum IN ( SELECT exportable_checksums.checksum
             FROM exportable_checksums)) AS exportable,
      COALESCE(a.annotations_count, (0)::bigint) AS annotations_count,
      COALESCE(c.comments_count, (0)::bigint) AS comments_count
     FROM (((sentences s
       JOIN texts t ON ((t.id = s.text_id)))
       LEFT JOIN exportable_annotation_checksums a USING (checksum))
       LEFT JOIN exportable_comment_checksums c USING (checksum))
    WHERE ((s."position" IS NOT NULL) AND (s.excluded_from_export = false))
    WINDOW w AS (PARTITION BY s.text_id ORDER BY s."position");
  SQL

  add_index "sentence_mappings", ["edition_id"], name: "index_sentence_mappings_on_edition_id", using: :btree
  add_index "sentence_mappings", ["exportable"], name: "index_sentence_mappings_on_exportable", using: :btree
  add_index "sentence_mappings", ["sentence_id"], name: "index_sentence_mappings_on_sentence_id", unique: true, using: :btree
  add_index "sentence_mappings", ["text_id"], name: "index_sentence_mappings_on_text_id", using: :btree

end
