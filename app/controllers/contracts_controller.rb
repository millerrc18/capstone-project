class ContractsController < ApplicationController
  before_action :set_program, only: %i[new create]

  def index
    @contracts = Contract.includes(:program).all
  end

  def show
    @contract = Contract.find(params[:id])
    @periods  = @contract.contract_periods.order(:period_start_date)
    @milestones = @contract.delivery_milestones.order(:due_date)
    @units = @contract.delivery_units.order(:ship_date, :unit_serial)
  end

  def new
    @contract = @program.contracts.build
  end

  def create
    @contract = @program.contracts.build(contract_params)
    if @contract.save
      redirect_to @contract, notice: 'Contract was successfully created.'
    else
      render :new
    end
  end

  def edit
    @contract = Contract.find(params[:id])
  end

  def update
    @contract = Contract.find(params[:id])
    if @contract.update(contract_params)
      redirect_to @contract, notice: 'Contract was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @contract = Contract.find(params[:id])
    @contract.destroy
    redirect_to program_path(@contract.program), notice: 'Contract was successfully destroyed.'
  end

  private

  def set_program
    @program = Program.find(params[:program_id])
  end

  def contract_params
    params.require(:contract).permit(
      :program_id,
      :contract_code,
      :fiscal_year,
      :start_date,
      :end_date,
      :planned_quantity,
      :sell_price_per_unit,
      :notes
    )
  end
end
