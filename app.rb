require 'sinatra'

require_relative './schedule'

get '/' do
  haml :index, format: :html5, locals: {schedule: Schedule.get_schedule}
end