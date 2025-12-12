class AddUniqueIndexesToDeliveryTables < ActiveRecord::Migration[7.0]
  def change
    add_index :delivery_milestones, [:contract_id, :due_date], unique: true
    add_index :delivery_units, [:contract_id, :unit_serial], unique: true
    add_index :contract_periods, [:contract_id, :period_start_date, :period_type],
          unique: true,
          name: "idx_cp_contract_date_type"
  end
end
