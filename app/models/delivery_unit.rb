# == Schema Information
#
# Table name: delivery_units
#
#  id          :bigint           not null, primary key
#  notes       :text
#  ship_date   :date
#  unit_serial :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  contract_id :bigint           not null
#
# Indexes
#
#  index_delivery_units_on_contract_id                  (contract_id)
#  index_delivery_units_on_contract_id_and_unit_serial  (contract_id,unit_serial) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#
class DeliveryUnit < ApplicationRecord
  belongs_to :contract

  validates :unit_serial, presence: true, uniqueness: { scope: :contract_id }
end
