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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121213204620) do

  create_table "annotations", :force => true do |t|
    t.integer  "text_id"
    t.integer  "sentence"
    t.string   "ip"
    t.integer  "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "annotations", ["text_id"], :name => "index_annotations_on_text_id"

  create_table "authors", :force => true do |t|
    t.string "name"
    t.string "institution"
  end

  create_table "authors_texts", :id => false, :force => true do |t|
    t.integer "text_id",   :null => false
    t.integer "author_id", :null => false
  end

  create_table "chapters", :force => true do |t|
    t.string   "label"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "part_id"
  end

  create_table "editions", :force => true do |t|
    t.string   "label"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "sorting"
  end

  create_table "parts", :force => true do |t|
    t.string   "label"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "sorting"
  end

  create_table "texts", :force => true do |t|
    t.text     "body"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "title"
    t.text     "abstract"
    t.text     "notes"
    t.text     "bibliography"
    t.string   "source_file"
    t.integer  "part_id"
    t.integer  "edition_id"
  end

end
