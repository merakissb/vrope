class Contract < ApplicationRecord
  belongs_to :building

  has_one_attached :file

  validates :file, content_type: ['application/pdf'], size: { less_than: 10.megabytes }
  validates :start_date, :end_date, :price, :currency, presence: true
  validate :end_date_after_start_date, if: -> { start_date.present? && end_date.present? }

  enum :status, { draft: 0, active: 1, expired: 2 }, default: :draft

  private

  def end_date_after_start_date
    return if end_date > start_date

    errors.add(:end_date, "must be after the start date")
  end
end
