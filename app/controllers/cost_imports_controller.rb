class CostImportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @programs = current_user.programs.order(:name)
  end

  def create
    @programs = current_user.programs.order(:name)
    if params[:program_id].blank?
      flash.now[:alert] = "Please select a program."
      render :new, status: :unprocessable_entity
      return
    end

    @program = current_user.programs.find_by(id: params[:program_id])
    unless @program
      flash.now[:alert] = "Not authorized."
      render :new, status: :forbidden
      return
    end

    if params[:file].blank?
      flash.now[:alert] = "Please choose a file."
      render :new, status: :unprocessable_entity
      return
    end

    result = CostImportService.new(user: current_user, program: @program, file: params[:file]).call

    if result[:errors].any?
      flash.now[:alert] = "Import failed: #{result[:errors].join(' ')}"
      render :new, status: :unprocessable_entity
    else
      @import_result = result
      flash.now[:notice] = "Costs imported. Created: #{result[:created]}."
      render :new
    end
  rescue StandardError => e
    flash.now[:alert] = "Import failed: #{e.message}"
    render :new, status: :unprocessable_entity
  end

  private
end
