class Building < ApplicationRecord
  belongs_to :property_manager

  has_many :contracts, dependent: :destroy
  has_many :services, dependent: :destroy

  # acceso de clientes
  has_many :building_clients
  has_many :clients, through: :building_clients, source: :user

  validates :name, :rut, :address_reference, :floors, presence: true
  validates :rut, presence: true, uniqueness: { case_sensitive: false }

  validates :floors, numericality: { only_integer: true, greater_than: 0 }
  validates :underground_floors, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
