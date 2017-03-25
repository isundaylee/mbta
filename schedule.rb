class Schedule
  # Route name => [Stop ID, Bus ID]
  ROUTES = {
    "MIT to Harvard" => [97, 1],
    "MIT to Boston" => [75, 1],
    "ADP to Harvard" => [101, 1],
    "ADP to Boston" => [73, 1],
    "Harvard to Boston" => [2168, 1],
  }

  API_KEY = ENV['MBTA_API_KEY']

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

  private
    def self.get_predictions(stop, bus)
      require 'http'

      json = JSON.parse(HTTP.get("http://realtime.mbta.com/developer/api/v2/predictionsbystop", params: {
        api_key: API_KEY,
        stop: stop,
        format: 'json'
      }).body)

      puts "Warning: More than 1 modes. Taking the first. " unless json['mode'].size == 1
      json = json['mode'][0]
      puts "Warning: More than 1 routes. Taking the first. " unless json['route'].size == 1
      json = json['route'][0]
      puts "Warning: More than 1 directions. Taking the first. " unless json['direction'].size == 1
      json = json['direction'][0]

      json['trip'].map { |trip| trip['pre_away'].to_i }
    end

end