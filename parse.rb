require_relative 'highest_cities'

# We assume that first argument is input file name
input_file = ARGV[0]

# We assume that second argument is output file name
output_file = ARGV[1]

# Writer to write in output file
writer = File.open(output_file, 'w')

# Now sort the hash by city altitude in descending order and then write to output file
highest_cities(input_file, ';').each do |city|
  output = "#{city[5]}m - #{city[2]}, #{city[1]}"
  puts output
  writer.puts(output)
end

writer.close
