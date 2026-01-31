# == Schema Information
#
# Table name: cost_imports
#
#  id              :bigint           not null, primary key
#  entries_count   :integer          default(0), not null
#  source_filename :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  program_id      :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_cost_imports_on_program_id  (program_id)
#  index_cost_imports_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (program_id => programs.id)
#  fk_rails_...  (user_id => users.id)
#
class CostImport < ApplicationRecord
  belongs_to :program
  belongs_to :user
  has_many :cost_entries, foreign_key: :import_id, dependent: :nullify
end
