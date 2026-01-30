require "rails_helper"

RSpec.describe CostImportService do
  class FakeSheet
    def initialize(rows)
      @rows = rows
    end

    def row(index)
      @rows[index - 1]
    end

    def last_row
      @rows.length
    end
  end

  let(:user) { User.create!(email: "costs@example.com", password: "password") }
  let(:program) { Program.create!(name: "Program", user: user) }
  let(:contract) do
    Contract.create!(
      program: program,
      contract_code: "C-100",
      start_date: Date.new(2024, 1, 1),
      end_date: Date.new(2024, 12, 31),
      sell_price_per_unit: 100,
      planned_quantity: 10
    )
  end

  def build_row(contract_code:)
    headers = described_class::REQUIRED_HEADERS
    headers.map do |header|
      case header
      when "contract_code"
        contract_code
      when "period_type"
        "week"
      when "period_start_date"
        Date.new(2024, 1, 1)
      when "notes"
        "Imported"
      else
        1
      end
    end
  end

  it "imports costs for the contract" do
    headers = described_class::REQUIRED_HEADERS
    rows = [headers, build_row(contract_code: "C-100")]
    sheet = FakeSheet.new(rows)

    service = described_class.new(user: user, contract: contract, file: double("file"))
    allow(service).to receive(:load_sheet).and_return(sheet)

    result = service.call

    expect(result[:created]).to eq(1)
    expect(ContractPeriod.count).to eq(1)
  end

  it "raises when contract_code does not match the contract" do
    headers = described_class::REQUIRED_HEADERS
    rows = [headers, build_row(contract_code: "OTHER")]
    sheet = FakeSheet.new(rows)

    service = described_class.new(user: user, contract: contract, file: double("file"))
    allow(service).to receive(:load_sheet).and_return(sheet)

    expect { service.call }
      .to raise_error("Row 2: contract_code must match C-100.")
  end
end
