class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :service_participants, dependent: :destroy
  has_many :services, through: :service_participants

  # acceso de clientes
  has_many :building_clients
  has_many :accessible_buildings, through: :building_clients, source: :building

  has_many :completed_tasks, class_name: "DailyTask", foreign_key: "completed_by_id"


  enum :role, { basic: 0, client: 1, admin: 2 }

  validates :first_name, :last_name, :rut, :birthdate, presence: true
  validates :rut, presence: true, uniqueness: { case_sensitive: false }

  def admin?
    role == "admin"
  end

  def client?
    role == "client"
  end
end
