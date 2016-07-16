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

ActiveRecord::Schema.define(version: 20160716163101) do

  create_table "admin_settings", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "allowance_details", force: :cascade do |t|
    t.integer  "level_id"
    t.integer  "employee_id"
    t.integer  "allowance_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["allowance_id"], name: "index_allowance_details_on_allowance_id"
    t.index ["employee_id"], name: "index_allowance_details_on_employee_id"
    t.index ["level_id"], name: "index_allowance_details_on_level_id"
  end

  create_table "allowances", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "benefits", force: :cascade do |t|
    t.integer  "employee_id"
    t.float    "trans_allowance"
    t.float    "beauty_allowance"
    t.float    "lunch_allawance"
    t.float    "bicyle_allowance"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["employee_id"], name: "index_benefits_on_employee_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "columns", force: :cascade do |t|
    t.string   "name"
    t.string   "display_name"
    t.string   "table_name"
    t.string   "attribute_name"
    t.integer  "index"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "uid"
    t.boolean  "insurance"
    t.string   "personal_deduction"
    t.integer  "number_of_dependence"
    t.float    "base_salary",          limit: 53
    t.integer  "category_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["category_id"], name: "index_employees_on_category_id"
  end

  create_table "fomulas", force: :cascade do |t|
    t.string   "name"
    t.string   "display_name"
    t.string   "expression"
    t.integer  "index"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "levels", force: :cascade do |t|
    t.integer  "level"
    t.float    "value"
    t.integer  "allowance_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["allowance_id"], name: "index_levels_on_allowance_id"
  end

  create_table "over_time_details", force: :cascade do |t|
    t.integer  "overtime_id"
    t.integer  "employee_id"
    t.float    "total_hour"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["employee_id"], name: "index_over_time_details_on_employee_id"
    t.index ["overtime_id"], name: "index_over_time_details_on_overtime_id"
  end

  create_table "over_times", force: :cascade do |t|
    t.string   "name"
    t.integer  "percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payslip_details", force: :cascade do |t|
    t.integer  "payslip_id"
    t.integer  "type"
    t.integer  "target_id"
    t.string   "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payslip_id"], name: "index_payslip_details_on_payslip_id"
  end

  create_table "payslips", force: :cascade do |t|
    t.integer  "employee_id"
    t.date     "time"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["employee_id"], name: "index_payslips_on_employee_id"
  end

  create_table "timesheets", force: :cascade do |t|
    t.date     "time"
    t.integer  "employee_id"
    t.float    "vacation_with_salary"
    t.float    "vacation_without_salary"
    t.float    "total_vacation_with_insurance_fee"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["employee_id"], name: "index_timesheets_on_employee_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role"
    t.integer  "employee_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_id"], name: "index_users_on_employee_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
