class AddUniqueIndexToContractsContractCode < ActiveRecord::Migration[8.0]
  def change
    add_index :contracts, :contract_code, unique: true
  end
end
