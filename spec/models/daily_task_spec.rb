require 'rails_helper'

RSpec.describe DailyTask, type: :model do
  describe 'Associations' do
    it { should belong_to(:service) }
    it { should belong_to(:completed_by).class_name('User').optional }
    it { should have_one_attached(:file) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end

  describe 'Attachments' do
    let(:service) { create(:service) }
    let(:task) { service.daily_tasks.first }

    context 'when file is invalid' do
      it 'rejects files that are too large' do
        task.file.attach(
          io: StringIO.new('a' * 11.megabytes),
          filename: 'oversized.pdf',
          content_type: 'application/pdf'
        )

        expect(task).not_to be_valid
      end

      it 'rejects unsupported file types' do
        task.file.attach(
          io: StringIO.new('fake'),
          filename: 'executable.exe',
          content_type: 'application/octet-stream'
        )

        expect(task).not_to be_valid
      end
    end
  end
end
