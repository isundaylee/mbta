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

      var texts = [];

      if (response.data.length == 0) {
        texts.push($('<span>').text('No predictions'));
      } else {
        _.each(_.first(response.data, 5), function(time) {
          texts.push($('<span>').text(Math.floor(time / 60.0) + 'm'));
        });
      }

      let el = $('#mbta_' + stop_id + '_' + bus_id + '_predictions');
      _.each(texts, function(text) {
        el.append(text);
      });
    });
  });
});
