# spec/models/property_manager_spec.rb
require 'rails_helper'

RSpec.describe PropertyManager, type: :model do
  subject { create(:property_manager) }

  it { should have_many(:buildings) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }
end
