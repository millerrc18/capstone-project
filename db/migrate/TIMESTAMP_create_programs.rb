class CreatePrograms < ActiveRecord::Migration[7.1]
  def change
    create_table :programs do |t|
      t.string :name, null: false
      t.string :customer
      t.text :description

      t.timestamps
    end
  end
end
