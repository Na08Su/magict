class Quotation < ApplicationRecord
  belongs_to :company
  has_many :construction_info
  has_many :quotation_details, dependent: :delete_all

  validates :name, presence: true
  validates :no, presence: true
  validate :quotation_details_should_be_exist, on: [:create, :update]

  accepts_nested_attributes_for :quotation_details, allow_destroy: true

  def import_details_from_csv_files(csv_files)
    fail CsvImporter::FileInvalid, I18n.t('errors.messages.not_selected_file') if csv_files.blank?

    transaction do
      save! # IDがないと親子関連が作れないので、保存する
      csv_options = { quotation: self }
      csv_files.each { |file| CsvImporter::QuotationDetailImporter.new(file: file, options: csv_options).execute }
    end
  end

  private

  def quotation_details_should_be_exist
    quotation_details.size <= 0
  end
end
