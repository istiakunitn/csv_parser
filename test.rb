require 'faker'
require_relative 'highest_cities'
require "test/unit"

class TestHighestCitiesFunction < Test::Unit::TestCase

  # Call before every single test
  def setup
    # We will generate some fake rows in test.csv so that we will use it for our test cases

    # Writer to write in test.csv file
    writer = File.open('test.csv', 'w')

    # This is the hash where we will store highest city of a country
    # Where hash key is the country and value is the csv row which represent a city
    # For example
    # {
    #     'Italy' => ["5386", "Italy", "Potenza", "40.6443170", "15.8085670", "698.0"],
    #     'XXXX' => "DDDD", "XXXX", "Xxxxx", "DD.DDDDD", "DD.DDDDDD", "DDD.D"],
    # }
    @highest = {}

    # This is the array where we will store random countries
    @countries = []
    5.times do
      @countries << Faker::Address.country
    end

    # Lets create some fake csv rows of city
    id = 1
    @countries.each do |country|
      5.times do
        city = Faker::Address.city
        latitude = Faker::Address.latitude
        longitude = Faker::Address.longitude
        altitude = Faker::Number.decimal((2..4).to_a.sample, 2)
        row = ["#{id}", country, city, latitude, longitude, altitude]
        if @highest[country].nil?
          # During first occurrence lets assume that first city has the highest altitude
          @highest[country] = row
        else
          # For other occurrences compare with the old stored highest altitude city
          # If current city has highest altitude then old, then replace the old highest altitude city with the current
          current_altitude = row[5].to_f
          old_highest_altitude = @highest[country][5].to_f
          if current_altitude > old_highest_altitude
            @highest[country] = row
          end
        end

        writer.puts("\"#{id}\";\"#{country}\";\"#{city}\";\"#{latitude}\";\"#{longitude}\";\"#{altitude}\"")
        id += 1
      end
    end
    writer.close

    # Now sort the hash by city altitude in descending order and then write to output file
    @expected_cities = @highest.values.sort { |city1, city2|
      city2[5].to_f <=> city1[5].to_f
    }
  end

  # Called after every single test
  def teardown
    # Delete the csv file
    File.delete('test.csv') if File.exist?('test.csv')
  end

  def test_input_file_not_found_exception
    assert_raise Exception do
      highest_cities('unknown.csv', ';')
    end
  end

  def test_cities_size
    assert_equal(@expected_cities.size, highest_cities('test.csv', ';').size)
  end

  def test_cities_order
    assert_equal(@expected_cities, highest_cities('test.csv', ';'))
  end
end