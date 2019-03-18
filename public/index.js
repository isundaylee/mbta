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
});
