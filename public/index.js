$(function() {
  window.data.bluebikes_station_ids.forEach(function(station_id) {
    axios.get('/api/bluebikes/' + station_id).then(function (response) {
      if (response.status != 200) {
        console.log("Failed to load Bluebikes info: ", response);
        return;
      }

      let el_bikes = $('<span>').text(response.data.bikes + " bikes");
      let el_docks = $('<span>').text(response.data.docks + " docks");

      if (response.data.bikes < 3) {
        el_bikes.addClass('verylow');
      } else if (response.data.bikes < 6) {
        el_bikes.addClass('low');
      }

      if (response.data.docks < 3) {
        el_docks.addClass('verylow');
      } else if (response.data.docks < 6) {
        el_docks.addClass('low');
      }

      $('#bluebikes_' + station_id + '_bikes').append(el_bikes);
      $('#bluebikes_' + station_id + '_bikes').append(el_docks);
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
