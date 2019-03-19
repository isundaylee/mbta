require 'json'
require 'http'

class Bluebikes
  DATA_URL = 'https://gbfs.bluebikes.com/gbfs/en/station_status.json'
  CACHE_THRESHOLD = 3.0

  @@mu = Mutex.new

  @@updated_at = nil
  @@cached_data = nil

  def self.get_station_status(station_id)
    get_data['data']['stations'].each do |station|
      if station['station_id'].to_i == station_id
        return {
          bikes: station['num_bikes_available'].to_i,
          docks: station['num_docks_available'].to_i,
        }
      end
    end

    nil
  end

  private
    def self.get_data
      @@mu.synchronize do
        if @@updated_at.nil? || (Time.now - @@updated_at > CACHE_THRESHOLD)
          @@updated_at = Time.now
          @@cached_data = HTTP.get(DATA_URL).parse
        end

        @@cached_data
      end
    end
end
