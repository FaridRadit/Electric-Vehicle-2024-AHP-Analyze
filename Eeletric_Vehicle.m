% Load the data
data = readtable('cars.csv');

% Display the first few rows to check if the data is loaded correctly
disp(data);

% Extract relevant columns for normalization
battery = data.Battery;
top_speed = data.Top_Speed;
efficiency = data.Efficiency;
fastcharge = data.Fastcharge;
us_price = data.Estimated_US_Value;

% Normalize the data (each value divided by the sum of its column)
battery_norm = battery / sum(battery);
top_speed_norm = top_speed / sum(top_speed);
efficiency_norm = efficiency / sum(efficiency);
fastcharge_norm = fastcharge / sum(fastcharge);
Estimated_US_Value = us_price / sum(us_price);

% Define weights (example weights, these should be adjusted based on your criteria)
weights = [0.23399, 0.09261, 0.1749, 0.11689, 0.38232];

% Combine normalized data into a matrix
normalized_data = [battery_norm, top_speed_norm, efficiency_norm, fastcharge_norm, Estimated_US_Value];

% Calculate the scores
scores = normalized_data * weights';

% Add scores to the table
data.Score = scores;

% Sort the table based on scores in descending order
sorted_data = sortrows(data, 'Score', 'descend');

% Add rank to the sorted data
sorted_data.Rank = (1:height(sorted_data))';

% Display the top ranked vehicles
disp(sorted_data(:, {'Brand', 'Model', 'Battery', 'Top_Speed', 'Efficiency', 'Fastcharge', 'Estimated_US_Value', 'Score', 'Rank'}));
