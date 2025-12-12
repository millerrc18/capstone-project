class PeriodImportsController < ApplicationController
  before_action :set_contract

  def new
  end

  def create
  file = params.dig(:period_import, :file)

  unless file.present?
    redirect_to new_contract_period_import_path(@contract), alert: "Please choose an .xlsx file."
    return
  end

  unless File.extname(file.original_filename).downcase == ".xlsx"
    redirect_to new_contract_period_import_path(@contract), alert: "Only .xlsx files are supported."
    return
  end

  import = ContractWorkbookImporter.new(contract: @contract, file: file).import!

  if import[:ok]
    r = import[:result]
    msg = [
      "Periods: +#{r[:periods][:created]} created, #{r[:periods][:updated]} updated",
      "Milestones: +#{r[:milestones][:created]} created, #{r[:milestones][:updated]} updated",
      "Units: +#{r[:units][:created]} created, #{r[:units][:updated]} updated"
    ].join(" | ")

    redirect_to contract_path(@contract), notice: "Workbook imported. #{msg}"
  else
    @errors = import[:errors]
    flash.now[:alert] = "Import failed. Fix the issues below and re-upload."
    render :new, status: :unprocessable_entity
  end
end


  private

  def set_contract
    @contract = Contract.joins(:program)
      .where(programs: { user_id: current_user.id })
      .find(params[:contract_id])
  end
end
