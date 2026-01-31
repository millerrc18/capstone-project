class CreateCostImports < ActiveRecord::Migration[8.0]
  def change
    create_table :cost_imports do |t|
      t.references :program, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :source_filename
      t.integer :entries_count, null: false, default: 0
      t.timestamps
    end

    add_foreign_key :cost_entries, :cost_imports, column: :import_id
  end
end
