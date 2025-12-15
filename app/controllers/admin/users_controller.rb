module Admin
  class UsersController < BaseController
    def index
      @users = User.order(created_at: :desc)
    end
  end
end
