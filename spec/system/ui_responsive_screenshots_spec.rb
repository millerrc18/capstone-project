require "rails_helper"
require "securerandom"

RSpec.describe "Responsive UI screenshots", type: :system, js: true do
  include UiScreenshotHelper

  before do
    driven_by(:cuprite, options: {
      timeout: 120,
      process_timeout: 60,
      browser_path: ENV["FERRUM_BROWSER_PATH"],
      browser_options: {
        "disable-gpu" => nil,
        "no-sandbox" => nil,
        "disable-dev-shm-usage" => nil
      }
    })
  end

  it "captures screenshots across Apple viewports" do
    user = User.create!(email: "ui-#{SecureRandom.hex(6)}@example.com", password: "password")
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
    click_button "Sign in"

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

        if width < 768
          ensure_mobile_media_query!(width, height)
          expect(page).to have_no_css(".sidebar.is-open")
          expect(page).to have_no_css("html.no-scroll")
          expect(page).to have_no_css(".sidebar-backdrop.is-open")
          assert_sidebar_nav_stacks_vertically!
          save_ui_screenshot(page_name, device_name, "closed")

          open_sidebar
          expect(page).to have_css(".sidebar.is-open")
          expect(page).to have_css(".sidebar-backdrop.is-open")
          expect(page).to have_css("html.no-scroll")
          save_ui_screenshot(page_name, device_name, "open")

          close_sidebar
          expect(page).to have_no_css(".sidebar.is-open")
          expect(page).to have_no_css(".sidebar-backdrop.is-open")
          expect(page).to have_no_css("html.no-scroll")
        else
          save_ui_screenshot(page_name, device_name, "closed")
        end
      end
    end
  end

  def assert_sidebar_nav_stacks_vertically!
    rects = sidebar_nav_rects
    expect(rects).not_to be_nil
    expect(rects.dig("second", "top")).to be > rects.dig("first", "top")
  end

  def open_sidebar
    find('button[aria-label="Open menu"]', visible: :all).click
  end

  def close_sidebar
    find(".sidebar-backdrop", visible: :all).trigger("click")
  end

  def sidebar_nav_rects
    evaluate_script(<<~JS)
      (() => {
        const links = document.querySelectorAll(".sidebar .sidebar-nav .nav-pill");
        if (links.length < 2) return null;
        const first = links[0].getBoundingClientRect();
        const second = links[1].getBoundingClientRect();
        return {
          first: { top: first.top, left: first.left },
          second: { top: second.top, left: second.left }
        };
      })()
    JS
  end

  def ensure_mobile_media_query!(width, height)
    set_viewport(width, height)
    page.evaluate_script("window.dispatchEvent(new Event('resize'))")
    is_mobile = page.evaluate_script("window.matchMedia('(max-width: 767px)').matches")
    expect(is_mobile).to be(true)
  end
end
