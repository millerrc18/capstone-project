class AddPrecisionToCostFields < ActiveRecord::Migration[8.0]
  def change
    change_column :contracts, :sell_price_per_unit, :decimal, precision: 15, scale: 2

    change_column :contract_periods, :revenue_per_unit, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :hours_bam, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :hours_eng, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :hours_mfg_soft, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :hours_mfg_hard, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :hours_touch, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :rate_bam, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :rate_eng, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :rate_mfg_soft, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :rate_mfg_hard, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :rate_touch, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :material_cost, :decimal, precision: 15, scale: 2
    change_column :contract_periods, :other_costs, :decimal, precision: 15, scale: 2
  end
end
