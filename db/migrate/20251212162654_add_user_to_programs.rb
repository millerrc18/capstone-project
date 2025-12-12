class AddUserToPrograms < ActiveRecord::Migration[7.0]
  def up
    add_reference :programs, :user, null: true, foreign_key: true

    # Create a default user to own existing programs (demo/admin).
    # If you already generated Devise User, this will work.
    user = User.first || User.create!(
      email: "demo@pmcopilot.com",
      password: "password",
      password_confirmation: "password"
    )

    execute <<~SQL
      UPDATE programs
      SET user_id = #{user.id}
      WHERE user_id IS NULL
    SQL

    change_column_null :programs, :user_id, false
  end

  def down
    remove_reference :programs, :user, foreign_key: true
  end
end
