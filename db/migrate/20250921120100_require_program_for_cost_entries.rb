class RequireProgramForCostEntries < ActiveRecord::Migration[8.0]
  class CostEntry < ApplicationRecord
    self.table_name = "cost_entries"
  end

  class CostImport < ApplicationRecord
    self.table_name = "cost_imports"
  end

  def up
    CostEntry.reset_column_information

    CostEntry.where(program_id: nil).find_each do |entry|
      next if entry.import_id.blank?

      import = CostImport.find_by(id: entry.import_id)
      entry.update_columns(program_id: import.program_id) if import&.program_id
    end

    CostEntry.where(program_id: nil).delete_all

    change_column_null :cost_entries, :program_id, false
  end

  def down
    change_column_null :cost_entries, :program_id, true
  end
end
