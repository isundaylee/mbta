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
  # Route name => [Stop ID, Bus ID]
  ROUTES = {
    "MIT to Harvard" => [107, 1],
    "MIT to Boston" => [75, 1],
    "ADP to Harvard" => [101, 1],
    "ADP to Boston" => [73, 1],
    "Harvard to Boston" => [2168, 1],
  }

  # Returns a hash with the keys being the route names, and the
  # values being lists of arrival times in seconds.
  def self.get_schedule()
    results = {}

    ROUTES.each do |name, params|
      stop, bus = params
      results[name] = self.get_predictions(stop, bus)
    end

    results
  end

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

  self.get_schedule()

end
