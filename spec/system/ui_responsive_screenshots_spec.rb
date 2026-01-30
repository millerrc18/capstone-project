require "rails_helper"

RSpec.describe "Responsive UI screenshots", type: :system, js: true do
  include UiScreenshotHelper

  before do
    driven_by(:headless_chrome)
  end

  it "captures screenshots across Apple viewports" do
    user = User.create!(email: "ui@example.com", password: "password")
    program = Program.create!(
      name: "Aurora",
      customer: "Lumen Labs",
      description: "AI-driven fulfillment pilot.",
      user: user
    )
    contract = Contract.create!(
      program: program,
      contract_code: "AUR-2024",
      start_date: Date.new(2024, 1, 1),
      end_date: Date.new(2024, 12, 31),
      sell_price_per_unit: 100,
      planned_quantity: 20
    )

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"

    pages = {
      "programs_index" => programs_path,
      "programs_show" => program_path(program),
      "contracts_show" => contract_path(contract),
      "imports_new" => new_contract_cost_import_path(contract),
      "docs_dashboard" => docs_path
    }

    pages.each do |page_name, path|
      APPLE_VIEWPORTS.each do |device_name, (width, height)|
        set_viewport(width, height)
        visit path
        expect(page).to have_css(".app-shell")
        save_ui_screenshot(page_name, device_name)
      end
    end
  end
end
