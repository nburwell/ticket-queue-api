class TicketsController < ApplicationController
  respond_to :json

  before_filter :find_ticket, except: [:index, :new, :create]
  
  SAFE_ATTRIBUTES = [:name, :message, :queue]
  def index
    tickets = params[:ticket_queue_id] ? Ticket.where(queue: params[:ticket_queue_id]) : Ticket.all
    render json: tickets
  end
  
  def show
    render json: @ticket
  end
  
  def create
    ticket = Ticket.create!(params[:ticket].permit(*SAFE_ATTRIBUTES))
    render json: ticket
  rescue ActiveRecord::RecordInvalid => ex
    render json: { success: false, errors: ex.message }, status: :unprocessable_entity    
  end
  
  def update
    ticket = @ticket.update_attributes!(params[:ticket].permit(*SAFE_ATTRIBUTES))
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
