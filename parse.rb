require 'csv'

# We assume that first argument is input file name
input_file = ARGV[0]

# We assume that second argument is output file name
output_file = ARGV[1]

# CSV reader to read from input file
reader = CSV.open(input_file, col_sep: ';')

# Writer to write in output file
writer = File.open(output_file, 'w')

# This is the hash where we will store highest city of a country
# Where hash key is the country and value is the csv row which represent a city
# For example
# {
#     'Italy' => ["5386", "Italy", "Potenza", "40.6443170", "15.8085670", "698.0"],
#     'XXXX' => "DDDD", "XXXX", "Xxxxx", "DD.DDDDD", "DD.DDDDDD", "DDD.D"],
# }
highest_cities = {}

# Read each row and find the highest city for each country
reader.each { |city|
  country = city[1]

  if highest_cities[country].nil?
    # During first occurrence lets assume that first city has the highest altitude
    highest_cities[country] = city
  else
    # For other occurrences compare with the old stored highest altitude city
    # If current city has highest altitude then old, then replace the old highest altitude city with the current
    current_altitude = city[5].to_f
    old_highest_altitude = highest_cities[country][5].to_f
    if current_altitude > old_highest_altitude
      highest_cities[country] = city
    end
  end
}

# Now sort the hash by city altitude in descending order and then write to output file
highest_cities.values.sort { |city1, city2|
  city2[5].to_f <=> city1[5].to_f
}.each do |city|
  writer.puts("#{city[5]}m - #{city[2]}, #{city[1]}")
end
