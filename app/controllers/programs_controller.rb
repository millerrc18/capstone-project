class ProgramsController < ApplicationController
  def index
    @programs = current_user.programs.order(:name)
  end

  def show
    @program = current_user.programs.find(params[:id])
    @dashboard = ProgramDashboard.new(@program).call
    @contracts = @program.contracts
  end

  def new
    @program = current_user.programs.new
  end

  def create
    @program = current_user.programs.new(program_params)
    if @program.save
      redirect_to @program, notice: 'Program was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @program = current_user.programs.find(params[:id])
  end

  def update
  @program = current_user.programs.find(params[:id])

    if @program.update(program_params)
      redirect_to @program, notice: "Program was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @program = current_user.programs.find(params[:id])
    @program.destroy
    redirect_to programs_url, notice: "Program was successfully destroyed."
  end

  private

  def program_params
    params.require(:program).permit(:name, :customer, :description)
  end
end
