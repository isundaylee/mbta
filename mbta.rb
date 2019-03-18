require 'jsonapi/consumer'

class Base < JSONAPI::Consumer::Resource
  self.site = 'https://api-v3.mbta.com/'
  self.connection_options = {
    params: {api_key: ENV['MBTA_API_KEY']},
  }
end

class Route < Base
  class Type
    BUS = 3
  end
end

class Prediction < Base
  has_one :route

  property :arrival_time, type: :time
  property :departure_time, type: :time
end

class MBTA

  def self.get_bus_predictions(stop_id, bus_id)
    get_predictions(stop_id, bus_id)
  end

  private
    def self.get_predictions(stop, bus)
      return Prediction.includes(:route).find(stop: stop).map do |pred|
        route = pred.route

        next if route['type'] != Route::Type::BUS
        next if route['id'].to_i != bus

        # Per https://www.mbta.com/developers/v3-api/best-practices
        seconds_until = (pred.arrival_time || pred.departure_time) - Time.now
        seconds_until
      end.compact
    end

end
