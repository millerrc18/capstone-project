# == Schema Information
#
# Table name: programs
#
#  id          :bigint           not null, primary key
#  customer    :string
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_programs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Program < ApplicationRecord
  belongs_to :user
  has_many :contracts, dependent: :destroy
  validates :name, presence: true

  def total_due_units
    contracts.sum { |c| c.total_due_units }
  end

  def on_time_units
    contracts.sum { |c| c.on_time_units }
  end

  def on_time_rate
    due = total_due_units
    return 0.0 if due == 0
    on_time_units.to_f / due
  end

end
