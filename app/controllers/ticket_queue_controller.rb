class TicketQueueController < ApplicationController
  def index
    $redis.set "foo", "from rails"
  end
end
