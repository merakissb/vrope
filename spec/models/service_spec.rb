# spec/models/service_spec.rb
require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'callbacks' do
    it 'creates daily tasks for each day in the service range' do
      start_date = Date.today
      end_date = start_date + 2.days
      service = create(:service, start_date: start_date, end_date: end_date)

      expect(service.daily_tasks.count).to eq(3)
      expect(service.daily_tasks.order(:date).pluck(:date)).to eq([start_date, start_date + 1.day, end_date])

      expect(service.daily_tasks.pluck(:name).uniq).to eq([ 'Charla Diaria' ])
    end
  end
end
