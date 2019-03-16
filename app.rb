require 'sinatra'

require_relative './mbta'
require_relative './bluebikes'

get '/' do
  haml :index, format: :html5, locals: {
    mbta_schedule: MBTA.get_schedule,
    bluebikes_status: Bluebikes.get_status,
  }
end
