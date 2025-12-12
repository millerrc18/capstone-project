class ContractPeriod < ApplicationRecord
  belongs_to :contract

  validates :period_start_date, :period_type, presence: true

  # cost calculations
  def total_labor_cost
    (hours_bam * rate_bam) +
    (hours_eng * rate_eng) +
    (hours_mfg_soft * rate_mfg_soft) +
    (hours_mfg_hard * rate_mfg_hard) +
    (hours_touch * rate_touch)
  end

  def total_cost
    total_labor_cost + (material_cost || 0) + (other_costs || 0)
  end

  def revenue_total
    units_delivered.to_f * revenue_per_unit
  end

  def cost_per_unit
    return 0 if units_delivered.to_i.zero?
    total_cost / units_delivered
  end

  def margin_per_unit
    revenue_per_unit - cost_per_unit
  end

  def total_margin
    revenue_total - total_cost
  end
end
