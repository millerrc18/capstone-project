class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def docs; end
end
