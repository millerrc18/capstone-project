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
  has_many :delivery_milestones, dependent: :destroy
  has_many :delivery_events, dependent: :destroy
  has_many :delivery_units, dependent: :destroy

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

  def total_due_units
    delivery_milestones.sum(:quantity_due).to_i
  end

  def total_shipped_units
    delivery_events.sum(:quantity_shipped).to_i
  end

  # Returns an array of hashes:
  # [{ milestone: <DeliveryMilestone>, on_time_qty: 2, late_qty: 1 }, ...]
  def milestone_performance
    milestones = delivery_milestones.order(:due_date).to_a
    events = delivery_events.order(:ship_date).to_a

    # Precompute cumulative shipped by date
    shipped_by_date = Hash.new(0)
    events.each { |e| shipped_by_date[e.ship_date] += e.quantity_shipped.to_i }

    cumulative = 0
    shipped_cum_by_date = {}
    shipped_by_date.keys.sort.each do |d|
      cumulative += shipped_by_date[d]
      shipped_cum_by_date[d] = cumulative
    end

    # Helper: shipped up to date
    shipped_upto = lambda do |date|
      # find the last date <= date
      key = shipped_cum_by_date.keys.select { |d| d <= date }.max
      key ? shipped_cum_by_date[key] : 0
    end

    allocated_on_time = 0
    milestones.map do |m|
      shipped_by_due = shipped_upto.call(m.due_date)
      available_for_this_due = [shipped_by_due - allocated_on_time, 0].max
      on_time = [m.quantity_due.to_i, available_for_this_due].min
      late = m.quantity_due.to_i - on_time

      allocated_on_time += on_time

      { milestone: m, on_time_qty: on_time, late_qty: late }
    end
  end

  def on_time_units
    milestone_performance.sum { |r| r[:on_time_qty] }
  end

  def late_units
    milestone_performance.sum { |r| r[:late_qty] }
  end

  def on_time_rate
    due = total_due_units
    return 0.0 if due == 0
    on_time_units.to_f / due
  end


end
