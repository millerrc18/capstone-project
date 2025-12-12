class CreateContractPeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :contract_periods do |t|
      t.references :contract, null: false, foreign_key: true
      t.date    :period_start_date, null: false
      t.string  :period_type, null: false  # "week" or "month"
      t.integer :units_delivered, default: 0
      t.decimal :revenue_per_unit, precision: 10, scale: 2

      # labor hours and rates by bucket
      t.decimal :hours_bam,       precision: 10, scale: 2, default: 0
      t.decimal :hours_eng,       precision: 10, scale: 2, default: 0
      t.decimal :hours_mfg_soft,  precision: 10, scale: 2, default: 0
      t.decimal :hours_mfg_hard,  precision: 10, scale: 2, default: 0
      t.decimal :hours_touch,     precision: 10, scale: 2, default: 0
      t.decimal :rate_bam,        precision: 10, scale: 2, default: 0
      t.decimal :rate_eng,        precision: 10, scale: 2, default: 0
      t.decimal :rate_mfg_soft,   precision: 10, scale: 2, default: 0
      t.decimal :rate_mfg_hard,   precision: 10, scale: 2, default: 0
      t.decimal :rate_touch,      precision: 10, scale: 2, default: 0

      # optional cost categories
      t.decimal :material_cost, precision: 12, scale: 2
      t.decimal :other_costs,   precision: 12, scale: 2

      t.timestamps
    end
  end
end
