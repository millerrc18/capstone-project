class CostEntriesController < ApplicationController
  helper_method :sort_direction_for

  before_action :set_cost_entry, only: [ :edit, :update, :destroy ]
  before_action :set_programs, only: [ :new, :create, :edit, :update ]

  def index
    @programs = current_user.programs.order(:name)
    @program = current_user.programs.find_by(id: params[:program_id]) if params[:program_id].present?

    @start_date = parsed_date(params[:start_date]) || Date.current.beginning_of_month
    @end_date = parsed_date(params[:end_date]) || Date.current

    if @start_date > @end_date
      flash.now[:alert] = "Start date cannot be after end date."
      @start_date = Date.current.beginning_of_month
      @end_date = Date.current
    end

    @sort = %w[date program].include?(params[:sort]) ? params[:sort] : "date"
    @direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"

    @entries = CostEntry.includes(:program)
                        .where(period_start_date: @start_date..@end_date)
    @entries = @entries.where(program_id: @program.id) if @program
    @entries = apply_sort(@entries)

    @summary = CostEntrySummary.new(
      start_date: @start_date,
      end_date: @end_date,
      program: @program
    ).call
  end

  def new
    @cost_entry = CostEntry.new(program: selected_program)
  end

  def create
    @cost_entry = CostEntry.new(cost_entry_params.except(:program_id))
    assign_program

    if @cost_entry.save
      redirect_to cost_hub_path, notice: "Cost entry created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @cost_entry.assign_attributes(cost_entry_params.except(:program_id))
    assign_program

    if @cost_entry.save
      redirect_to cost_hub_path, notice: "Cost entry updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cost_entry.destroy
    redirect_to cost_hub_path, notice: "Cost entry deleted."
  end

  private

  def set_cost_entry
    @cost_entry = CostEntry.find(params[:id])
  end

  def set_programs
    @programs = current_user.programs.order(:name)
  end

  def selected_program
    return nil if params[:program_id].blank?

    current_user.programs.find_by(id: params[:program_id])
  end

  def assign_program
    return @cost_entry.program = nil if cost_entry_params[:program_id].blank?

    @cost_entry.program = current_user.programs.find_by(id: cost_entry_params[:program_id])
  end

  def cost_entry_params
    params.require(:cost_entry).permit(
      :period_type,
      :period_start_date,
      :hours_bam,
      :hours_eng,
      :hours_mfg_salary,
      :hours_mfg_hourly,
      :hours_touch,
      :rate_bam,
      :rate_eng,
      :rate_mfg_salary,
      :rate_mfg_hourly,
      :rate_touch,
      :material_cost,
      :other_costs,
      :notes,
      :program_id
    )
  end

  def parsed_date(value)
    return nil if value.blank?

    Date.parse(value)
  rescue Date::Error
    nil
  end

  def apply_sort(scope)
    return scope.order(period_start_date: @direction) if @sort == "date"

    scope.left_joins(:program)
         .order("programs.name #{@direction}, cost_entries.period_start_date #{@direction}")
  end

  def sort_direction_for(column)
    if @sort == column && @direction == "asc"
      "desc"
    else
      "asc"
    end
  end
end
