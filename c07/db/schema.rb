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

ActiveRecord::Schema.define(version: 20160920002639) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_headings", force: :cascade, comment: "勘定科目" do |t|
    t.integer  "company_id",           null: false, comment: "企業ID"
    t.string   "code",                 null: false, comment: "コード"
    t.string   "name",                 null: false, comment: "名称"
    t.integer  "division",   limit: 2, null: false, comment: "区分"
    t.integer  "created_by",                        comment: "作成者ID"
    t.integer  "updated_by",                        comment: "更新者ID"
    t.datetime "deleted_at",                        comment: "削除日時"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["company_id", "code"], name: "index_account_headings_on_company_id_and_code", using: :btree
    t.index ["company_id", "division"], name: "index_account_headings_on_company_id_and_division", using: :btree
    t.index ["company_id"], name: "index_account_headings_on_company_id", using: :btree
  end

  create_table "budget_costs", force: :cascade, comment: "実行予算原価" do |t|
    t.integer  "budget_id",                     null: false, comment: "実行予算ID"
    t.integer  "cost_id",                       null: false, comment: "原価ID"
    t.float    "expense_rate",                               comment: "経費率"
    t.bigint   "quotation_submitted_amount",                 comment: "見積提出予算"
    t.bigint   "quotation_initial_cost_amount",              comment: "見積原価予算"
    t.bigint   "amount",                                     comment: "予算金額"
    t.bigint   "final_amount",                               comment: "最終予算金額"
    t.string   "recital",                                    comment: "備考"
    t.integer  "created_by",                                 comment: "作成者"
    t.integer  "updated_by",                                 comment: "更新者"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["budget_id"], name: "index_budget_costs_on_budget_id", using: :btree
    t.index ["cost_id"], name: "index_budget_costs_on_cost_id", using: :btree
  end

  create_table "budgets", force: :cascade, comment: "実行予算" do |t|
    t.integer  "contract_construction_id",                       null: false, comment: "担当工事ID"
    t.string   "no",                                             null: false, comment: "予算NO"
    t.integer  "status",                   limit: 2, default: 0, null: false, comment: "ステータス"
    t.integer  "created_by",                                                  comment: "作成者"
    t.integer  "updated_by",                                                  comment: "更新者"
    t.datetime "deleted_at",                                                  comment: "削除日時"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.index ["contract_construction_id"], name: "index_budgets_on_contract_construction_id", using: :btree
  end

  create_table "businesses", force: :cascade, comment: "業務" do |t|
    t.integer  "company_id",                                 null: false, comment: "企業ID"
    t.string   "code",                                       null: false, comment: "業務コード(決算開始期 + 採算区分 + 業務コード数値部)(不要ではあるが検索で必要となる為、カラムで保持しておく)"
    t.string   "name",                                       null: false, comment: "業務名"
    t.integer  "financial_start_year", limit: 2,             null: false, comment: "決算開始期"
    t.integer  "profit_division_id",                         null: false, comment: "採算区分ID"
    t.string   "code_number",                                null: false, comment: "業務コード数値部"
    t.integer  "status",               limit: 2, default: 0, null: false, comment: "ステータス(0:初期状態, 99:決算処理済)"
    t.integer  "created_by",                                              comment: "作成者ID"
    t.integer  "updated_by",                                              comment: "更新者ID"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["company_id"], name: "index_businesses_on_company_id", using: :btree
    t.index ["profit_division_id"], name: "index_businesses_on_profit_division_id", using: :btree
  end

  create_table "company_relations", force: :cascade, comment: "取引先情報" do |t|
    t.integer  "partner_company_id",                 null: false, comment: "相手の会社"
    t.integer  "own_company_id",                     null: false, comment: "自分の会社"
    t.string   "code",                               null: false, comment: "取引先CD"
    t.string   "own_company_code",                   null: false, comment: "取引先側で管理している自社のCD"
    t.string   "contact_person",                                  comment: "窓口担当者"
    t.string   "contact_tel",                                     comment: "窓口担当tel"
    t.string   "contact_fax",                                     comment: "窓口担当fax"
    t.date     "basic_contract_day",                              comment: "基本契約締結日"
    t.date     "start_up_date",                                   comment: "取引開始日"
    t.string   "recital1",                                        comment: "備考1"
    t.string   "recital2",                                        comment: "備考2"
    t.boolean  "customer_flag",      default: false,              comment: "受注先として使うか"
    t.boolean  "payee_flag",         default: false,              comment: "支払先として使うか"
    t.boolean  "vendor_flag",        default: false,              comment: "仕入先として使うか"
    t.integer  "created_by",                                      comment: "作成者ID"
    t.integer  "updated_by",                                      comment: "更新者ID"
    t.datetime "deleted_at",                                      comment: "削除日時"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["own_company_id", "code"], name: "index_company_relations_on_own_company_id_and_code", unique: true, using: :btree
    t.index ["own_company_id", "customer_flag"], name: "index_company_relations_on_own_company_id_and_customer_flag", using: :btree
    t.index ["own_company_id", "partner_company_id"], name: "index_company_relations_on_own_and_partner_company_id", unique: true, using: :btree
    t.index ["own_company_id", "payee_flag"], name: "index_company_relations_on_own_company_id_and_payee_flag", using: :btree
    t.index ["own_company_id", "vendor_flag"], name: "index_company_relations_on_own_company_id_and_vendor_flag", using: :btree
    t.index ["own_company_id"], name: "index_company_relations_on_own_company_id", using: :btree
    t.index ["partner_company_id"], name: "index_company_relations_on_partner_company_id", using: :btree
  end

  create_table "company_settings", force: :cascade, comment: "システム共通設定" do |t|
    t.integer  "company_id",          null: false, comment: "企業ID"
    t.integer  "financial_year",      null: false, comment: "期"
    t.integer  "closing_first_year",  null: false, comment: "決算1期目の年"
    t.integer  "closing_start_month", null: false
    t.float    "consumption_tax",     null: false, comment: "消費税"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["company_id"], name: "index_company_settings_on_company_id", using: :btree
  end

  create_table "construction_infos", force: :cascade, comment: "営業中工事情報" do |t|
    t.integer  "company_id",                               null: false, comment: "企業ID"
    t.string   "site_name",                                null: false, comment: "現場名"
    t.string   "construction_name",                        null: false, comment: "工事名"
    t.string   "enactment_location",                       null: false, comment: "施工場所(市町村名)"
    t.integer  "financial_year",                           null: false, comment: "決算期"
    t.integer  "master_construction_model_id",                          comment: "受注形態ID"
    t.integer  "master_construction_probability_id",                    comment: "受注確率ID"
    t.integer  "first_master_construction_probability_id",              comment: "登録時受注確率ID"
    t.integer  "customer_company_id",                                   comment: "受注先"
    t.date     "schedule_start",                                        comment: "工事工程 開始日"
    t.date     "schedule_end",                                          comment: "工事工程 終了日"
    t.date     "enactment_schedule_start",                              comment: "施工工程 開始日"
    t.date     "enactment_schedule_end",                                comment: "施工工程 終了日"
    t.integer  "technical_employee_id",                                 comment: "技術担当者"
    t.integer  "sales_employee_id",                                     comment: "営業担当者"
    t.integer  "foreman_employee_id",                                   comment: "工事担当者"
    t.string   "building_contractor",                                   comment: "建築業者"
    t.bigint   "expected_amount",                                       comment: "予定金額"
    t.integer  "quotation_id",                                          comment: "見積"
    t.integer  "master_bill_division_id",                               comment: "請求区分ID"
    t.string   "recital",                                               comment: "備考"
    t.integer  "created_by",                                            comment: "作成者ID"
    t.integer  "updated_by",                                            comment: "更新者ID"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["company_id"], name: "index_construction_infos_on_company_id", using: :btree
    t.index ["master_bill_division_id"], name: "index_construction_infos_on_master_bill_division_id", using: :btree
    t.index ["master_construction_model_id"], name: "index_construction_infos_on_master_construction_model_id", using: :btree
    t.index ["master_construction_probability_id"], name: "index_construction_infos_on_master_construction_probability_id", using: :btree
    t.index ["quotation_id"], name: "index_construction_infos_on_quotation_id", using: :btree
  end

  create_table "contract_constructions", force: :cascade, comment: "担当工事" do |t|
    t.integer  "company_id",                                     null: false, comment: "企業ID"
    t.integer  "construction_info_id",                                        comment: "工事情報ID"
    t.integer  "business_id",                                    null: false, comment: "業務ID"
    t.integer  "financial_year",                                 null: false, comment: "決算期"
    t.string   "code",                                           null: false, comment: "工番"
    t.string   "name",                                           null: false, comment: "工事名"
    t.date     "schedule_start",                                              comment: "工事工程 開始日"
    t.date     "schedule_end",                                                comment: "工事工程 終了日"
    t.date     "enactment_schedule_start",                                    comment: "施工工程 開始日"
    t.date     "enactment_schedule_end",                                      comment: "施工工程 終了日"
    t.integer  "construction_division",    limit: 2,                          comment: "工事区分"
    t.integer  "contract_division",        limit: 2,                          comment: "請負区分"
    t.integer  "technical_employee_id",                                       comment: "技術担当者"
    t.integer  "sales_employee_id",                                           comment: "営業担当者"
    t.integer  "foreman_employee_id",                                         comment: "工事担当者"
    t.integer  "quotation_id",                                                comment: "見積"
    t.string   "decision_no",                                                 comment: "決定NO"
    t.bigint   "decision_amount",                                             comment: "決定金額"
    t.bigint   "decision_amount_tax",                                         comment: "決定金額消費税"
    t.date     "decision_date",                                               comment: "決定日付"
    t.integer  "order_status",             limit: 2, default: 1,              comment: "受注ステータス"
    t.integer  "progress",                 limit: 2, default: 0,              comment: "進捗"
    t.string   "recital",                                                     comment: "備考"
    t.integer  "created_by",                                                  comment: "作成者ID"
    t.integer  "updated_by",                                                  comment: "更新者ID"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.index ["business_id"], name: "index_contract_constructions_on_business_id", using: :btree
    t.index ["company_id"], name: "index_contract_constructions_on_company_id", using: :btree
    t.index ["construction_info_id"], name: "index_contract_constructions_on_construction_info_id", using: :btree
    t.index ["quotation_id"], name: "index_contract_constructions_on_quotation_id", using: :btree
  end

  create_table "control_trading_accounts", force: :cascade, comment: "取引先口座" do |t|
    t.integer  "company_id",        null: false, comment: "企業ID"
    t.string   "bank_code",         null: false, comment: "銀行コード"
    t.string   "bank_branch_code",  null: false, comment: "支店コード"
    t.string   "account_number",    null: false, comment: "口座番号"
    t.string   "account_name",      null: false, comment: "口座名義"
    t.string   "account_name_kana", null: false, comment: "口座名義カナ"
    t.string   "bank_short_name",   null: false, comment: "銀行名略称"
    t.string   "account_headings",  null: false, comment: "勘定科目"
    t.string   "limit_borrowing",                comment: "借入限度額"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["company_id"], name: "index_control_trading_accounts_on_company_id", using: :btree
  end

  create_table "costs", force: :cascade, comment: "原価" do |t|
    t.integer  "company_id",                   null: false, comment: "企業ID"
    t.integer  "account_heading_id",                        comment: "勘定科目ID"
    t.integer  "code",                         null: false, comment: "原価コード"
    t.string   "name",                         null: false, comment: "原価名"
    t.integer  "cost_class",         limit: 2, null: false, comment: "原価分類"
    t.integer  "budget_class",       limit: 2, null: false, comment: "予算分類"
    t.integer  "created_by",                                comment: "作成者ID"
    t.integer  "updated_by",                                comment: "更新者ID"
    t.datetime "deleted_at",                                comment: "削除日時"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["account_heading_id"], name: "index_costs_on_account_heading_id", using: :btree
    t.index ["company_id", "budget_class"], name: "index_costs_on_company_id_and_budget_class", using: :btree
    t.index ["company_id", "code"], name: "index_costs_on_company_id_and_code", using: :btree
    t.index ["company_id", "cost_class"], name: "index_costs_on_company_id_and_cost_class", using: :btree
    t.index ["company_id"], name: "index_costs_on_company_id", using: :btree
  end

  create_table "customers", force: :cascade, comment: "受注先情報" do |t|
    t.integer  "company_relation_id",                             comment: "会社情報"
    t.integer  "category",                 limit: 2,              comment: "カテゴリ"
    t.integer  "cutoff_date",                                     comment: "締日"
    t.integer  "cutoff_date_cycle",        limit: 2,              comment: "締日サイクル"
    t.string   "arrival_day_of_submittal",                        comment: "提出必着日"
    t.integer  "receipt_date",                                    comment: "入金日"
    t.boolean  "receipt_account_code",                            comment: "指定請求書"
    t.integer  "draft_site",                                      comment: "手形サイト"
    t.string   "receipt_term",                                    comment: "入金条件"
    t.integer  "created_by",                                      comment: "作成者ID"
    t.integer  "updated_by",                                      comment: "更新者ID"
    t.datetime "deleted_at",                                      comment: "削除日時"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["company_relation_id"], name: "index_customers_on_company_relation_id", using: :btree
  end

  create_table "departments", force: :cascade, comment: "部署マスタ" do |t|
    t.integer  "division_id", null: false, comment: "部門ID"
    t.string   "code",        null: false, comment: "コード"
    t.string   "name",        null: false, comment: "部署名"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["division_id"], name: "index_departments_on_division_id", using: :btree
  end

  create_table "disbursement_costs", force: :cascade, comment: "出金伝票用支払内容" do |t|
    t.integer  "company_id", null: false, comment: "企業ID"
    t.string   "name",       null: false, comment: "支払内容"
    t.integer  "cost_id",                 comment: "原価ID"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_disbursement_costs_on_company_id", using: :btree
  end

  create_table "divisions", force: :cascade, comment: "部門" do |t|
    t.integer  "company_id", null: false, comment: "企業ID"
    t.string   "code",       null: false, comment: "部門コード"
    t.string   "name",       null: false, comment: "名称"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_divisions_on_company_id", using: :btree
  end

  create_table "master_bank_branches", force: :cascade, comment: "銀行支店マスタ" do |t|
    t.string   "master_bank_code", null: false, comment: "銀行コード"
    t.string   "code",             null: false, comment: "支店コード"
    t.string   "name",             null: false, comment: "支店名"
    t.string   "name_kana",        null: false, comment: "支店名カナ"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["master_bank_code"], name: "index_master_bank_branches_on_master_bank_code", using: :btree
  end

  create_table "master_banks", primary_key: "code", id: :string, comment: "銀行コード", force: :cascade, comment: "銀行マスタ" do |t|
    t.string   "name",       null: false, comment: "銀行名"
    t.string   "name_kana",  null: false, comment: "銀行名カナ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "master_bill_divisions", force: :cascade, comment: "請求区分マスタ" do |t|
    t.string   "name",       null: false, comment: "請求区分名称"
    t.integer  "created_by",              comment: "作成者ID"
    t.integer  "updated_by",              comment: "更新者ID"
    t.datetime "deleted_at",              comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "master_construction_models", force: :cascade, comment: "受注形態マスタ" do |t|
    t.string   "name",                        null: false, comment: "受注形態名称"
    t.string   "name_short",                               comment: "受注形態名称略称(帳票用)"
    t.integer  "code_order",                  null: false, comment: "並び順"
    t.boolean  "bundle_flag", default: false, null: false, comment: "一括フラグ"
    t.integer  "created_by",                               comment: "作成者ID"
    t.integer  "updated_by",                               comment: "更新者ID"
    t.datetime "deleted_at",                               comment: "削除日時"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "master_construction_probabilities", force: :cascade do |t|
    t.string   "code",       null: false, comment: "受注確率CD"
    t.string   "name",       null: false, comment: "受注確率名"
    t.integer  "created_by",              comment: "作成者ID"
    t.integer  "updated_by",              comment: "更新者ID"
    t.datetime "deleted_at",              comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payees", force: :cascade, comment: "支払先情報" do |t|
    t.integer  "company_relation_id",                 comment: "会社情報"
    t.integer  "cutoff_date",                         comment: "締日"
    t.integer  "payment_account",                     comment: "支払情報-振込"
    t.integer  "payment_check",                       comment: "支払情報-小切手"
    t.integer  "payment_cash",                        comment: "支払情報-現金"
    t.integer  "payment_note_payable",                comment: "支払情報-支払手形"
    t.integer  "draft_site",                          comment: "手形サイト"
    t.integer  "payment_notice",                      comment: "支払通知"
    t.integer  "master_bank_branch_id",               comment: "銀行-支店"
    t.integer  "bank_account_type",                   comment: "口座種別"
    t.string   "bank_account_number",                 comment: "口座番号"
    t.string   "bank_account_name",                   comment: "口座名義"
    t.string   "bank_account_name_kana",              comment: "口座名義カナ"
    t.integer  "created_by",                          comment: "作成者ID"
    t.integer  "updated_by",                          comment: "更新者ID"
    t.datetime "deleted_at",                          comment: "削除日時"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["company_relation_id"], name: "index_payees_on_company_relation_id", using: :btree
    t.index ["master_bank_branch_id"], name: "index_payees_on_master_bank_branch_id", using: :btree
  end

  create_table "profit_divisions", force: :cascade, comment: "採算区分" do |t|
    t.integer  "company_id", null: false, comment: "企業ID"
    t.string   "name",       null: false, comment: "名称"
    t.integer  "created_by",              comment: "作成者"
    t.integer  "updated_by",              comment: "更新者"
    t.datetime "deleted_at",              comment: "削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_profit_divisions_on_company_id", using: :btree
  end

  create_table "quotation_details", force: :cascade, comment: "見積詳細(行単位)" do |t|
    t.integer  "quotation_id",                       comment: "見積ID"
    t.integer  "cost_id",                            comment: "原価ID"
    t.integer  "row_number",            null: false, comment: "行番号"
    t.string   "name1",                 null: false, comment: "名称1"
    t.string   "name2",                              comment: "名称2"
    t.string   "unit",                               comment: "単位"
    t.integer  "submitted_quantity",                 comment: "提出数量"
    t.bigint   "submitted_price",                    comment: "提出単価"
    t.integer  "initial_cost_quantity",              comment: "原価数量"
    t.bigint   "initial_cost_price",                 comment: "原価単価"
    t.integer  "created_by",                         comment: "作成者"
    t.integer  "updated_by",                         comment: "更新者"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["quotation_id"], name: "index_quotation_details_on_quotation_id", using: :btree
  end

  create_table "quotations", force: :cascade, comment: "見積" do |t|
    t.integer  "company_id",     null: false, comment: "企業ID"
    t.string   "no",             null: false, comment: "見積NO"
    t.string   "name",                        comment: "見積名"
    t.date     "submitted_date",              comment: "見積提出日"
    t.integer  "created_by",                  comment: "作成者"
    t.integer  "updated_by",                  comment: "更新者"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["company_id"], name: "index_quotations_on_company_id", using: :btree
  end

  create_table "regular_debit_accounts", force: :cascade, comment: "定例引落管理" do |t|
    t.integer  "company_id",                 null: false, comment: "企業ID"
    t.integer  "control_trading_account_id", null: false, comment: "取引先口座ID"
    t.integer  "drawer_type",                null: false, comment: "引落タイプ"
    t.integer  "withdrawal_month",           null: false, comment: "引落月"
    t.string   "withdrawal_day",             null: false, comment: "引落日"
    t.string   "payment_content",            null: false, comment: "支払い内容"
    t.string   "payment_content_detail",                  comment: "詳細"
    t.string   "payment_amount",             null: false, comment: "支払い金額"
    t.datetime "deleted_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["company_id"], name: "index_regular_debit_accounts_on_company_id", using: :btree
    t.index ["control_trading_account_id"], name: "index_regular_debit_accounts_on_control_trading_account_id", using: :btree
  end

  create_table "slip_details", force: :cascade, comment: "伝票詳細" do |t|
    t.integer  "slip_id",                   null: false, comment: "伝票ID"
    t.integer  "slip_resource_id",                       comment: "資金ID"
    t.integer  "division_id",                            comment: "部門"
    t.integer  "contract_construction_id",               comment: "担当工事ID"
    t.integer  "cost_id",                                comment: "原価ID"
    t.integer  "debit_account_heading_id",               comment: "借方勘定科目ID"
    t.integer  "credit_account_heading_id",              comment: "貸方勘定科目ID"
    t.integer  "row_number",                             comment: "行番号"
    t.string   "summary",                                comment: "摘要"
    t.string   "summary_item",                           comment: "摘要(品目)"
    t.date     "summary_date",                           comment: "摘要(日付)"
    t.bigint   "amount",                                 comment: "金額"
    t.datetime "deleted_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["contract_construction_id"], name: "index_slip_details_on_contract_construction_id", using: :btree
    t.index ["cost_id"], name: "index_slip_details_on_cost_id", using: :btree
    t.index ["division_id"], name: "index_slip_details_on_division_id", using: :btree
    t.index ["slip_id"], name: "index_slip_details_on_slip_id", using: :btree
    t.index ["slip_resource_id"], name: "index_slip_details_on_slip_resource_id", using: :btree
  end

  create_table "slip_resources", force: :cascade, comment: "資金" do |t|
    t.integer  "company_id", null: false, comment: "企業ID"
    t.string   "code",       null: false, comment: "資金コード"
    t.string   "name",       null: false, comment: "名称"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_slip_resources_on_company_id", using: :btree
  end

  create_table "slip_types", force: :cascade, comment: "伝票分類" do |t|
    t.integer  "company_id",   null: false, comment: "企業ID"
    t.string   "code",         null: false, comment: "伝票分類コード"
    t.string   "name",         null: false, comment: "名称"
    t.integer  "order_number", null: false, comment: "順番"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["company_id"], name: "index_slip_types_on_company_id", using: :btree
  end

  create_table "slips", force: :cascade, comment: "伝票" do |t|
    t.integer  "company_id",     null: false, comment: "企業ID"
    t.string   "code",           null: false, comment: "伝票番号"
    t.integer  "financial_year", null: false, comment: "決算期"
    t.integer  "slip_type_id",   null: false, comment: "伝票分類"
    t.date     "slip_date",      null: false, comment: "伝票日付"
    t.datetime "deleted_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["company_id"], name: "index_slips_on_company_id", using: :btree
    t.index ["slip_type_id"], name: "index_slips_on_slip_type_id", using: :btree
  end

  create_table "vendors", force: :cascade, comment: "仕入先情報" do |t|
    t.integer  "company_relation_id",                        comment: "会社情報"
    t.integer  "category",            limit: 2,              comment: "種別"
    t.integer  "payee_id",                                   comment: "支払先"
    t.integer  "account_heading_id",                         comment: "未払時勘定科目"
    t.integer  "created_by",                                 comment: "作成者ID"
    t.integer  "updated_by",                                 comment: "更新者ID"
    t.datetime "deleted_at",                                 comment: "削除日時"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["account_heading_id"], name: "index_vendors_on_account_heading_id", using: :btree
    t.index ["company_relation_id"], name: "index_vendors_on_company_relation_id", using: :btree
    t.index ["payee_id"], name: "index_vendors_on_payee_id", using: :btree
  end

end
