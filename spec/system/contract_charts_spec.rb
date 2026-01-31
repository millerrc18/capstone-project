require "rails_helper"

RSpec.describe "Contract charts", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "renders charts on the contract page" do
    user = User.create!(email: "charts@example.com", password: "password")
    program = Program.create!(name: "Nimbus", user: user)
    contract = Contract.create!(
      program: program,
      contract_code: "NB-101",
      start_date: Date.new(2024, 1, 1),
      end_date: Date.new(2024, 12, 31),
      sell_price_per_unit: 100,
      planned_quantity: 12
    )

    ContractPeriod.create!(
      contract: contract,
      period_start_date: Date.new(2024, 1, 1),
      period_type: "month",
      units_delivered: 3,
      revenue_per_unit: 100,
      material_cost: 50,
      other_costs: 10
    )

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Sign in"

    visit contract_path(contract)

    expect(page).to have_content("Delivered units trend")
    expect(page).to have_css("canvas[data-controller='chart']", count: 2)
  end
end
