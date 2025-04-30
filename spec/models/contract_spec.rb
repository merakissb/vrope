require 'rails_helper'

RSpec.describe Contract, type: :model do
  describe 'validations' do
    subject(:contract) { build(:contract) }

    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:currency) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }

    context 'with invalid dates' do
      it 'is invalid if end_date is before start_date' do
        contract.start_date = Date.today
        contract.end_date = Date.yesterday
        expect(contract).not_to be_valid
        expect(contract.errors[:end_date]).to include("must be after the start date")
      end
    end

    context 'with attached file' do
      it 'accepts a valid PDF file' do
        contract = build(:contract, :with_pdf)
        expect(contract).to be_valid
      end

      it 'rejects a non-PDF file' do
        contract.file.attach(
          io: StringIO.new('invalid content'),
          filename: 'fake.txt',
          content_type: 'text/plain'
        )
        expect(contract).not_to be_valid
      end

      it 'rejects a PDF that is too large' do
        contract.file.attach(
          io: StringIO.new('a' * 11.megabytes),
          filename: 'big.pdf',
          content_type: 'application/pdf'
        )
        expect(contract).not_to be_valid
      end
    end
  end

  describe 'status management' do
    it 'defaults to draft on creation' do
      contract = create(:contract)
      expect(contract.status).to eq('draft')
    end
  end
end
