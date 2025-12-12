# == Schema Information
#
# Table name: contracts
#
#  id                  :bigint           not null, primary key
#  contract_code       :string
#  end_date            :date
#  fiscal_year         :integer
#  notes               :text
#  planned_quantity    :integer
#  sell_price_per_unit :decimal(, )
#  start_date          :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_id          :bigint           not null
#
# Indexes
#
#  index_contracts_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_...  (program_id => programs.id)
#
class Contract < ApplicationRecord
  belongs_to :program
  has_many :contract_periods, dependent: :destroy

  validates :contract_code, :start_date, :end_date, :sell_price_per_unit, presence: true

  # aggregated helpers
  def total_units_delivered
    contract_periods.sum(:units_delivered).to_i
  end

  def total_revenue
    contract_periods.sum { |p| p.revenue_total.to_f }
  end

  def total_cost
    contract_periods.sum { |p| p.total_cost.to_f }
  end

  def total_margin
    total_revenue - total_cost
  end

  def average_cost_per_unit
    units = total_units_delivered
    return 0 if units == 0
    total_cost / units
  end

  def average_margin_per_unit
    units = total_units_delivered
    return 0 if units == 0
    total_margin / units
  end

  # Optional aliases if you ever used different names elsewhere
  alias_method :avg_cost_per_unit, :average_cost_per_unit
  alias_method :avg_margin_per_unit, :average_margin_per_unit
  
end
