class PropertyManager < ApplicationRecord
  has_many :buildings

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
