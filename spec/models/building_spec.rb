require 'rails_helper'

RSpec.describe Building, type: :model do
  describe 'associations' do
    it { should belong_to(:property_manager) }
    it { should have_many(:contracts).dependent(:destroy) }
    it { should have_many(:services).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:building) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:rut) }
    it { should validate_presence_of(:address_reference) }
    it { should validate_presence_of(:floors) }

    it { should validate_uniqueness_of(:rut).case_insensitive }

    it { should validate_numericality_of(:floors).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:underground_floors).only_integer.is_greater_than_or_equal_to(0) }
  end
end
