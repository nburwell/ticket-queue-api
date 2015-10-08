require 'rubygems'
require 'colorize'
require 'rack'
require 'json'
require 'rest-client'

class ApiLogger
  def <<(message)
    unless message[/^# =>/]
      puts message.colorize(:yellow)
    end
  end
end

RestClient.log = ApiLogger.new

def api
  puts ''
  begin
    response = yield
    show_response(response, :light_green)
  rescue RestClient::ExceptionWithResponse => ex
    show_response(ex.response, :light_red)
  end
end

def show_response response, color
  puts "---"
  puts "Status:   " + "#{response.code} (#{Rack::Utils::HTTP_STATUS_CODES[response.code]})".colorize(color)
  
  puts response.headers.inspect
  body = 
    begin
      JSON.pretty_generate(JSON.parse(response.body))
    rescue JSON::ParserError => ex
      response.body
    end

  puts "Response: #{body.colorize(:light_cyan)}"
  puts "---\n\n"
  nil
end

# ------------------------------
/localhost:3002/tickets")

TICKET_NAME = "api test"
Ticket.where(name: TICKET_NAME).destroy_all

api { resource.get }

# create new
api { resource.post({ ticket: { name: TICKET_NAME } }) }

api { resource.get }

# validation case
api { resource.post({ ticket: { name: TICKET_NAME } }) }

# update existing
t = Ticket.last

api { resource["#{t.id}.json"].put({ ticket: { name: "#{TICKET_NAME} - updated" } }) }

api { resource.get }

# destroy it 
api { resource["#{t.id}.json"].delete() }

api { resource.get }