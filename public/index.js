$(function() {
  window.data.bluebikes_station_ids.forEach(function(station_id) {
    axios.get('/api/bluebikes/' + station_id).then(function (response) {
      if (response.status != 200) {
        console.log("Failed to load Bluebikes info: ", response);
        return;
      }

      $('#bluebikes_' + station_id + '_bikes').text(response.data.bikes);
      $('#bluebikes_' + station_id + '_docks').text(response.data.docks);
    });
  });

  window.data.mbta_route_ids.forEach(function(ids) {
    let stop_id = ids[0]
    let bus_id = ids[1]

    axios.get('/api/mbta/' + stop_id + '/' + bus_id).then(function (response) {
      if (response.status != 200) {
        console.log('Failed to load MBTA info: ', response);
        return;
      }

      var text = 'No predictions';
      if (response.data.length > 0) {
        times = _.first(response.data, 5);
        words = _.map(times, function(time) {
          return Math.floor(time / 60.0) + 'm';
        });
        text = words.join(', ');
      }

      $('#mbta_' + stop_id + '_' + bus_id + '_predictions').text(text);
    });
  });
});
