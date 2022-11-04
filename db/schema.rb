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

ActiveRecord::Schema[7.0].define(version: 2022_10_26_094346) do
  create_table "expenses", charset: "utf8mb4", force: :cascade do |t|
    t.text "description"
    t.decimal "amount", precision: 10
    t.date "dateOfExpense"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", charset: "utf8mb4", force: :cascade do |t|
    t.integer "transaction_id"
    t.integer "product_id"
    t.decimal "quantity", precision: 10
    t.decimal "price", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", charset: "utf8mb4", force: :cascade do |t|
    t.date "dateOfPayment"
    t.decimal "amount", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "point_of_sales", charset: "utf8mb4", force: :cascade do |t|
    t.integer "subscription_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", charset: "utf8mb4", force: :cascade do |t|
    t.integer "pos_id"
    t.string "productName"
    t.decimal "quantity", precision: 10
    t.decimal "pricePerUnit", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales", charset: "utf8mb4", force: :cascade do |t|
    t.integer "pos_id"
    t.date "dateOfSales"
    t.decimal "netSales", precision: 10
    t.decimal "grossSales", precision: 10
    t.decimal "beginningBalance", precision: 10
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.decimal "payment", precision: 10
    t.date "dateOfPayment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", charset: "utf8mb4", force: :cascade do |t|
    t.integer "pos_id"
    t.date "dateOfTransaction"
    t.decimal "totalPrice", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "unsubscriptionDate"
    t.date "renewDate"
  end

end
