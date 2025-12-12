# == Schema Information
#
# Table name: delivery_events
#
#  id               :bigint           not null, primary key
#  notes            :text
#  quantity_shipped :integer
#  ship_date        :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  contract_id      :bigint           not null
#
# Indexes
#
#  index_delivery_events_on_contract_id  (contract_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#
class DeliveryEvent < ApplicationRecord
  belongs_to :contract

  validates :ship_date, presence: true
  validates :quantity_shipped, numericality: { greater_than_or_equal_to: 0 }
end
