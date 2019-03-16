require 'sinatra'

require_relative './mbta'

get '/' do
  haml :index, format: :html5, locals: {schedule: MBTA.get_schedule}
end
