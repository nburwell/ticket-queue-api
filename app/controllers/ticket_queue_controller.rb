class TicketQueueController < ApplicationController
  def index
    @ticket_counts = Ticket.group(:queue).count
  end
end
