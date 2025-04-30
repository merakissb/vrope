# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  it { should have_many(:service_participants).dependent(:destroy) }
  it { should have_many(:services).through(:service_participants) }
  it { should have_many(:completed_tasks).class_name('DailyTask').with_foreign_key('completed_by_id') }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:rut) }
  it { should validate_presence_of(:birthdate) }

  it { should validate_uniqueness_of(:rut).case_insensitive }
end
