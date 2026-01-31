require "rails_helper"

RSpec.describe CostEntry, type: :model do
  it "is valid with required fields" do
    user = User.create!(email: "cost-entry@example.com", password: "password")
    program = Program.create!(name: "Cost Program", user: user)

    entry = described_class.new(
      program: program,
      period_type: "week",
      period_start_date: Date.new(2024, 1, 1),
      material_cost: 100,
      other_costs: 25
    )

    expect(entry).to be_valid
  end

  it "rejects invalid period types" do
    user = User.create!(email: "cost-entry-period@example.com", password: "password")
    program = Program.create!(name: "Cost Program", user: user)

    entry = described_class.new(
      program: program,
      period_type: "quarter",
      period_start_date: Date.new(2024, 1, 1),
      material_cost: 100,
      other_costs: 0
    )

    expect(entry).not_to be_valid
    expect(entry.errors[:period_type]).not_to be_empty
  end

  it "requires non-negative numeric values for hours" do
    user = User.create!(email: "cost-entry-hours@example.com", password: "password")
    program = Program.create!(name: "Cost Program", user: user)

    entry = described_class.new(
      program: program,
      period_type: "month",
      period_start_date: Date.new(2024, 1, 1),
      hours_bam: -1,
      material_cost: 100,
      other_costs: 0
    )

    expect(entry).not_to be_valid
    expect(entry.errors[:hours_bam]).not_to be_empty
  end

  it "allows negative material cost values" do
    user = User.create!(email: "cost-entry-material@example.com", password: "password")
    program = Program.create!(name: "Cost Program", user: user)

    entry = described_class.new(
      program: program,
      period_type: "month",
      period_start_date: Date.new(2024, 1, 1),
      material_cost: -25,
      other_costs: 0
    )

    expect(entry).to be_valid
  end

  it "computes total costs" do
    user = User.create!(email: "cost-entry-total@example.com", password: "password")
    program = Program.create!(name: "Cost Program", user: user)

    entry = described_class.new(
      program: program,
      period_type: "week",
      period_start_date: Date.new(2024, 1, 1),
      hours_bam: 2,
      rate_bam: 50,
      material_cost: 100,
      other_costs: 25
    )

    expect(entry.total_labor_hours).to eq(2.to_d)
    expect(entry.total_labor_cost).to eq(100.to_d)
    expect(entry.total_cost).to eq(225.to_d)
  end

  it "requires a program" do
    entry = described_class.new(
      period_type: "week",
      period_start_date: Date.new(2024, 1, 1),
      material_cost: 100,
      other_costs: 25
    )

    expect(entry).not_to be_valid
    expect(entry.errors[:program]).not_to be_empty
  end
end
