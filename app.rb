require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader'

require_relative './mbta'
require_relative './bluebikes'

also_reload 'mbta.rb'
also_reload 'bluebikes.rb'

get '/api/bluebikes/:station_id' do
  station_id = params[:station_id].to_i

  json Bluebikes.get_station_status(station_id)
end

get '/' do
  haml :index, format: :html5, locals: {
    mbta_schedule: MBTA.get_schedule,
    bluebikes_status: Bluebikes.get_status,
  }
end
