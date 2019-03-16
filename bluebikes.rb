require 'json'
require 'http'

class Bluebikes
  STATIONS = {
    'Ashdown': 178,
    'BCS': 80,
    'Flour': 184,
    'Trader Joe\'s': 105,
    'H-Mart': 68,
    'Kendall': 189,
    'Ames St': 107,
  }

  DATA_URL = 'https://gbfs.bluebikes.com/gbfs/en/station_status.json'

  def self.get_status
    data = HTTP.get(DATA_URL).parse

    data_by_station_id = {}
    data['data']['stations'].each do |station|
      data_by_station_id[station['station_id'].to_i] = {
        bikes: station['num_bikes_available'].to_i,
        docks: station['num_docks_available'].to_i,
      }
    end

    STATIONS.transform_values do |station_id|
      data_by_station_id[station_id]
    end.compact
  end
end
