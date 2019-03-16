require 'sinatra'

require_relative './mbta'

get '/' do
  haml :index, format: :html5, locals: {mbta_schedule: MBTA.get_schedule}
end
