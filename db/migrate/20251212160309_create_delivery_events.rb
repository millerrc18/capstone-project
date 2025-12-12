class CreateDeliveryEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :delivery_events do |t|
      t.references :contract, null: false, foreign_key: true
      t.date :ship_date
      t.integer :quantity_shipped
      t.text :notes

      t.timestamps
    end
  end
end
