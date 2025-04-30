class Service < ApplicationRecord
  # associations
  belongs_to :building

  has_many :service_participants, dependent: :destroy
  has_many :users, through: :service_participants
  has_many :daily_tasks, dependent: :destroy

  # validations
  validates :name, :start_date, :end_date, :building_id, presence: true
  validate :end_date_after_start_date

  # enum
  enum :status, {
    pending: 0,
    coordinating: 1,
    in_progress: 2,
    qa: 3,
    done: 4
  }, default: :pending

  # callbacks
  after_create :generate_daily_tasks

  private

  def generate_daily_tasks
    return if start_date.blank? || end_date.blank?

    (start_date.to_date..end_date.to_date).each do |day|
      daily_tasks.create!(
        name: "Charla Diaria",
        description: "Sesión de charla obligatoria del día.",
        date: day
      )
    end
  end

  def end_date_after_start_date
    if start_date.present? && end_date.present? && end_date < start_date
      errors.add(:end_date, "debe ser posterior a la fecha de inicio")
    end
  end
end
