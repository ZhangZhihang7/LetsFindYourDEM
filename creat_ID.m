% Create latitude list (lat_list)
lat = (60:-5:-55)';                         % Latitude values from 60 to -60, step -5
lat_ID = compose('%02d', (1:24)');           % Generate lat_ID from 01 to 24
lat_list = table(lat, lat_ID);               % Create a table with lat and lat_ID
save('lat_list.mat', 'lat_list');            % Save as lat_list.mat

% Create longitude list (lon_list)
lon = (-180:5:175)';                         % Longitude values from -180 to 180, step 5
lon_ID = compose('%02d', (1:72)');           % Generate lon_ID from 01 to 72
lon_list = table(lon, lon_ID);               % Create a table with lon and lon_ID
save('lon_list.mat', 'lon_list');            % Save as lon_list.mat
