class ProgramsController < ApplicationController
  def index
    @programs = Program.all
  end

  def show
    @program = Program.find(params[:id])
    @contracts = @program.contracts
  end

  def new
    @program = Program.new
  end

  def create
    @program = Program.new(program_params)
    if @program.save
      redirect_to @program, notice: 'Program was successfully created.'
    else
      render :new
    end
  end

  def edit
    @program = Program.find(params[:id])
  end

  def update
    @program = Program.find(params[:id])
    if @program.update(program_params)
      redirect_to @program, notice: 'Program was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @program = Program.find(params[:id])
    @program.destroy
    redirect_to programs_url, notice: 'Program was successfully destroyed.'
  end

  private

  def program_params
    params.require(:program).permit(:name, :customer, :description)
  end
end