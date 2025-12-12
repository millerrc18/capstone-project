class CreateDeliveryUnits < ActiveRecord::Migration[8.0]
  def change
    create_table :delivery_units do |t|
      t.references :contract, null: false, foreign_key: true
      t.string :unit_serial
      t.date :ship_date
      t.text :notes

      t.timestamps
    end
  end
end
