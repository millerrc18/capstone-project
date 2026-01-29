require "rails_helper"

RSpec.describe Program, type: :model do
  describe "on-time delivery helpers" do
    it "does not expose legacy delivery helper methods" do
      program = described_class.new

      expect(program).not_to respond_to(:total_due_units)
      expect(program).not_to respond_to(:on_time_units)
      expect(program).not_to respond_to(:on_time_rate)
    end
  end
end
