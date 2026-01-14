class CostImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_scope

  def new; end

  def create
    if params[:file].blank?
      redirect_to new_cost_import_path, alert: "Please choose a file."
      return
    end

    result = CostImportService.new(
      user: current_user,
      contract: @contract,
      program: @program,
      file: params[:file]
    ).call

    notice = import_notice(result)
    redirect_to import_redirect_path, notice: notice
  rescue => e
    redirect_to new_cost_import_path, alert: "Import failed: #{e.message}"
  end

  private

  def set_scope
    if params[:contract_id].present?
      @contract = Contract.find(params[:contract_id])
      @program = @contract.program
    elsif params[:program_id].present?
      @program = Program.find(params[:program_id])
    end

    unless @program&.user_id == current_user.id
      redirect_to programs_path, alert: "Not authorized."
    end
  end

  def new_cost_import_path
    return new_contract_cost_import_path(@contract) if @contract.present?
    return new_program_cost_import_path(@program) if @program.present?

    programs_path
  end

  def import_redirect_path
    return contract_path(@contract) if @contract.present?
    return program_path(@program) if @program.present?

    programs_path
  end

  def import_notice(result)
    base = "Costs imported. Created: #{result[:created]}, updated: #{result[:updated]}."
    return base if result[:per_contract].blank?

    breakdown = result[:per_contract].map do |code, counts|
      "#{code} (#{counts[:created]} created, #{counts[:updated]} updated)"
    end.join(", ")
    "#{base} By contract: #{breakdown}."
  end
end
