class CreateContracts < ActiveRecord::Migration[7.1]
  def change
    create_table :contracts do |t|
      t.references :program, null: false, foreign_key: true
      t.string  :contract_code, null: false
      t.integer :fiscal_year
      t.date    :start_date, null: false
      t.date    :end_date, null: false
      t.integer :planned_quantity
      t.decimal :sell_price_per_unit, precision: 10, scale: 2, null: false
      t.text    :notes

      t.timestamps
    end
  end
end
