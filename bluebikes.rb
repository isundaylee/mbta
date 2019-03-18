require 'json'
require 'http'

class Bluebikes
  DATA_URL = 'https://gbfs.bluebikes.com/gbfs/en/station_status.json'

  def self.get_station_status(station_id)
    data = HTTP.get(DATA_URL).parse

    data['data']['stations'].each do |station|
      if station['station_id'].to_i == station_id
        return {
          bikes: station['num_bikes_available'].to_i,
          docks: station['num_docks_available'].to_i,
        }
      end
    end

    nil
  end
end
