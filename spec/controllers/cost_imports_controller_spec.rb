require "rails_helper"

RSpec.describe CostImportsController, type: :controller do
  describe "GET #new" do
    it "redirects when the user does not own the contract" do
      owner = User.create!(email: "owner@example.com", password: "password")
      other = User.create!(email: "other@example.com", password: "password")
      program = Program.create!(name: "Program", user: owner)
      contract = Contract.create!(
        program: program,
        contract_code: "C-200",
        start_date: Date.new(2024, 1, 1),
        end_date: Date.new(2024, 12, 31),
        sell_price_per_unit: 100,
        planned_quantity: 10
      )

      sign_in other

      get :new, params: { contract_id: contract.id }

      expect(response).to redirect_to(programs_path)
      expect(flash[:alert]).to eq("Not authorized.")
    end
  end
end
