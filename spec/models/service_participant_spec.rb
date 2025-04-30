require 'rails_helper'

RSpec.describe ServiceParticipant, type: :model do
  describe 'associations' do
    it { should belong_to(:service) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { create(:service_participant) }

    it { should validate_presence_of(:role) }

    it {
      should validate_uniqueness_of(:service_id)
        .scoped_to(:user_id)
        .with_message("ya está asignado a este servicio")
    }
  end
end
