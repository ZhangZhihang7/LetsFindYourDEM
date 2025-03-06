% Clear the output dir
outputPath = '.\DEMYouWanted';  % confirm ur outputpath
% get all the file
files = dir(fullfile(outputPath, '*'));  
% delete all file in your output_dir
for k = 1:length(files)
    if ~files(k).isdir  %
        delete(fullfile(outputPath, files(k).name));  
    end
end
fprintf('ALL FILE IN THE OUTPUT_PATH  %s HAVE BEEN DELETED.\n', outputPath);
% Load the latitude and longitude lists
load('lon_list.mat', 'lon_list');
load('lat_list.mat', 'lat_list');
% Input coordinates for the two points
lon1 = input('Enter the longitude for Point 1: ');
lat1 = input('Enter the latitude for Point 1: ');
lon2 = input('Enter the longitude for Point 2: ');
lat2 = input('Enter the latitude for Point 2: ');
% Function to find tile ID based on given longitude and latitude
findTileID = @(lon, lat) ...
    struct('lon_ID', find(lon_list.lon <= lon & (lon_list.lon + 5) > lon, 1), ...
           'lat_ID', find(lat_list.lat >= lat & (lat_list.lat - 5) < lat, 1));
% Find tile IDs for Point 1 and Point 2
point1 = findTileID(lon1, lat1);
point2 = findTileID(lon2, lat2);
% Check if both points are within range
if isempty(point1.lon_ID) || isempty(point1.lat_ID)
    error('Point 1 is out of the defined tile range.');
end
if isempty(point2.lon_ID) || isempty(point2.lat_ID)
    error('Point 2 is out of the defined tile range.');
end
% Get tile names for Point 1 and Point 2
file1 = sprintf('srtm_%s_%s.tif', lon_list.lon_ID{point1.lon_ID}, lat_list.lat_ID{point1.lat_ID});
file2 = sprintf('srtm_%s_%s.tif', lon_list.lon_ID{point2.lon_ID}, lat_list.lat_ID{point2.lat_ID});
fprintf('Point 1 tile: %s\n', file1);
fprintf('Point 2 tile: %s\n', file2);
% % Extract row and column indices from the file names
% [row1, col1] = sscanf(file1, 'srtm_%02d_%02d.tif');
% [row2, col2] = sscanf(file2, 'srtm_%02d_%02d.tif');
% Get row and column indices directly from lon_ID and lat_ID
col1 = str2double(lat_list.lat_ID{point1.lat_ID});
row1 = str2double(lon_list.lon_ID{point1.lon_ID});
col2 = str2double(lat_list.lat_ID{point2.lat_ID});
row2 = str2double(lon_list.lon_ID{point2.lon_ID});
% Determine the range for rows and columns
startRow = min(row1, row2);
endRow = max(row1, row2);
startCol = min(col1, col2);
endCol = max(col1, col2);
% Define source directory containing .tif files and target directory
sourceDir = '.\Global_DEM_tif_file';  % Path to the directory containing original .tif files
targetDir = '.\DEMYouWanted';  % Path to the directory where files will be copied
% Ensure the target directory exists
if ~exist(targetDir, 'dir')
    mkdir(targetDir);
end
% Loop through the specified range of rows and columns
for row = startRow:endRow
    for col = startCol:endCol
        % Generate the file name for the current tile
        tileName = sprintf('srtm_%02d_%02d.tif', row, col);
        sourceFile = fullfile(sourceDir, tileName);  % Full path to the source file
        targetFile = fullfile(targetDir, tileName);  % Full path to the target file

        % Check if the file exists in the source directory
        if exist(sourceFile, 'file')
            % Copy the file to the target directory
            copyfile(sourceFile, targetFile);
            fprintf('Copied %s to %s\n', sourceFile, targetFile);
        else
            fprintf('File %s does not exist in the source directory.It might be an ocean area.\n', sourceFile);
        end
    end
end
