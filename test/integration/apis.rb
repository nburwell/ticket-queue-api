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
  
  json = nil
  body = 
    begin
      json = JSON.parse(response.body)
      JSON.pretty_generate(json)
    rescue JSON::ParserError => ex
      response.body
    end

  puts "Response: #{body.colorize(:light_cyan)}"
  puts "---\n\n"

  json
end

# ------------------------------
resource = RestClient::Resource.new("http://localhost:3002/tickets")

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


# queues
api { resource.post({ ticket: { name: TICKET_NAME, queue: "a" } }) }
api { resource.post({ ticket: { name: TICKET_NAME + "b1", queue: "b" } }) }
api { resource.post({ ticket: { name: TICKET_NAME + "b2", queue: "b" } }) }

json = api { resource.get }
if json
  if json.length == 3
    puts "Found #{json.length}"
  else
    raise "Unexpected length of tickets found: #{json.length}"
  end
else
  raise "ERROR getting response in queues test"
end

queue_resource = RestClient::Resource.new("http://localhost:3002/ticket_queues/b/tickets")

json = api { queue_resource.get }
if json
  if json.length == 2
    puts "Found #{json.length}"
  else
    raise "Unexpected length of tickets found: #{json.length}"
  end
else
  raise "ERROR getting response in queues test"
end