# spec/models/service_participant_spec.rb
require 'rails_helper'

RSpec.describe ServiceParticipant, type: :model do
  subject { create(:service_participant) }

  it { should belong_to(:service) }
  it { should belong_to(:user) }

  it { should define_enum_for(:role).with_values(
    operator: 0,
    supervisor: 1,
    operations_manager: 2,
    safety_officer: 3
  )}

  it { should validate_presence_of(:role) }

  it "valida unicidad de usuario por servicio" do
    sp = create(:service_participant)
    dup = build(:service_participant, user: sp.user, service: sp.service)

    expect(dup).not_to be_valid
    expect(dup.errors[:service_id]).to include("ya está asignado a este servicio")
  end
end
