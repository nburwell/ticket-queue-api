class TicketsController < ApplicationController
  respond_to :json

  before_filter :find_ticket, except: [:index, :new, :create]
  
  def index
    tickets = Ticket.all
    render json: tickets
  end
  
  def show
    render json: @ticket
  end
  
  def create
    ticket = Ticket.create!(params[:ticket].permit(:name, :message))
    render json: ticket
  rescue ActiveRecord::RecordInvalid => ex
    render json: { success: false, errors: ex.message }, status: :unprocessable_entity    
  end
  
  def update
    ticket = @ticket.update_attributes!(params[:ticket].permit(:name, :message))
    render json: ticket
  rescue ActiveRecord::RecordInvalid => ex
    render json: { success: false, errors: ex.message }, status: :unprocessable_entity    
  end
  
  def destroy
    @ticket.destroy
    render json: { success: true }
  end
  
  private
  
  def find_ticket
    @ticket = Ticket.find(params[:id])
  end
end
