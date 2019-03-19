require 'json'

require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader'

require_relative './mbta'
require_relative './bluebikes'

also_reload 'mbta.rb'
also_reload 'bluebikes.rb'

# Route name => [Stop ID, Bus ID]
MBTA_ROUTES = {
  "MIT Out" => [107, 1],
  "MIT In" => [75, 1],
  "Harvard In" => [2168, 1],
}

BLUEBIKES_STATIONS = {
  'Ashdown': 178,
  'BCS': 80,
  'Flour': 184,
  'Trader Joe\'s': 105,
  'H-Mart': 68,
  'Kendall': 189,
  'Ames St': 107,
}

get '/api/bluebikes/:station_id' do
  station_id = params[:station_id].to_i

  json Bluebikes.get_station_status(station_id)
end

get '/api/mbta/:stop_id/:bus_id' do
  stop_id = params[:stop_id].to_i
  bus_id = params[:bus_id].to_i

  json MBTA.get_bus_predictions(stop_id, bus_id)
end

get '/' do
  haml :index, format: :html5, locals: {
    mbta_routes: MBTA_ROUTES,
    bluebikes_stations: BLUEBIKES_STATIONS,
  }
end
