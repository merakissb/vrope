class DailyTask < ApplicationRecord
  belongs_to :service
  belongs_to :completed_by, class_name: "User", optional: true

  has_one_attached :file

  validates :file, content_type: [ "image/jpeg" ], size: { less_than: 5.megabytes }
  validates :date, :name, :description, presence: true

  enum :status, {
    pending: 0,
    completed: 1,
    expired: 2
  }, default: :pending

  # callbacks
  before_save :check_completion

  private

  def check_completion
    if file.attached? && completed_by_id.present?
      self.status = :completed
      self.completed_at ||= Time.current
    end
  end
end
