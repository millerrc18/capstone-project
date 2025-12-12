class Contract < ApplicationRecord
  belongs_to :program
  has_many :contract_periods, dependent: :destroy

  validates :contract_code, :start_date, :end_date, :sell_price_per_unit, presence: true

  # aggregated helpers
  def total_units_delivered
    contract_periods.sum(:units_delivered)
  end

  def total_cost
    contract_periods.sum(&:total_cost)
  end

  def total_revenue
    contract_periods.sum(&:revenue_total)
  end

  def average_cost_per_unit
    return 0 if total_units_delivered.zero?
    total_cost / total_units_delivered
  end

  def average_margin_per_unit
    return 0 if total_units_delivered.zero?
    (total_revenue - total_cost) / total_units_delivered
  end
end
