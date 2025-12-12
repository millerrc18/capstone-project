class CreateDeliveryMilestones < ActiveRecord::Migration[8.0]
  def change
    create_table :delivery_milestones do |t|
      t.references :contract, null: false, foreign_key: true
      t.date :due_date
      t.integer :quantity_due
      t.text :notes

      t.timestamps
    end
  end
end
