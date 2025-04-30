class ServiceParticipant < ApplicationRecord
  belongs_to :service
  belongs_to :user

  validates :role, presence: true
  validates :service_id, uniqueness: { scope: :user_id, message: "ya está asignado a este servicio" }

  enum :role, {
    operator: 0,
    supervisor: 1,
    operations_manager: 2,
    safety_officer: 3
  }
end
