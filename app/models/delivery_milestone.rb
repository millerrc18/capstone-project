# == Schema Information
#
# Table name: delivery_milestones
#
#  id           :bigint           not null, primary key
#  due_date     :date
#  notes        :text
#  quantity_due :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  contract_id  :bigint           not null
#
# Indexes
#
#  index_delivery_milestones_on_contract_id               (contract_id)
#  index_delivery_milestones_on_contract_id_and_due_date  (contract_id,due_date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#
class DeliveryMilestone < ApplicationRecord
  belongs_to :contract

  validates :due_date, presence: true, uniqueness: { scope: :contract_id }
  validates :quantity_due, numericality: { greater_than_or_equal_to: 0 }
end
