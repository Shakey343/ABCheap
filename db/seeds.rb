
# FakeData.create!(
#   origin: "London Golders Green",
#   destination: "Edinburgh",
#   cost: 14.90,
#   start_time: DateTime.new(2022,3,18,9,5,0),
#   end_time: DateTime.new(2022,3,18,19,10,0),
#   duration: 605,
#   mode: "bus"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Golders Green",
#   destination: "Edinburgh",
#   cost: 19.60,
#   start_time: DateTime.new(2022,3,18,17,55,0),
#   end_time: DateTime.new(2022,3,19,7,40,0),
#   duration: 825,
#   mode: "bus"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Golders Green",
#   destination: "Edinburgh",
#   cost: 37.60,
#   start_time: DateTime.new(2022,3,18,18,45,0),
#   end_time: DateTime.new(2022,3,19,8,5,0),
#   duration: 800,
#   mode: "bus"
# )
# puts "data added"


# FakeData.create!(
#   origin: "London Finchley Road",
#   destination: "Edinburgh",
#   cost: 14.99,
#   start_time: DateTime.new(2022,3,18,9,55,0),
#   end_time: DateTime.new(2022,3,18,19,0,0),
#   duration: 545,
#   mode: "bus"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Finchley Road",
#   destination: "Edinburgh",
#   cost: 9.99,
#   start_time: DateTime.new(2022,3,18,22,25,0),
#   end_time: DateTime.new(2022,3,18,7,0,0),
#   duration: 515,
#   mode: "bus"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Kings Cross",
#   destination: "Edinburgh",
#   cost: 59,
#   start_time: DateTime.new(2022,3,18,10,45,0),
#   end_time: DateTime.new(2022,3,18,15,17,0),
#   duration: 286,
#   mode: "train"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Kings Cross",
#   destination: "Edinburgh Waverley",
#   cost: 69,
#   start_time: DateTime.new(2022,3,18,10,0,0),
#   end_time: DateTime.new(2022,3,18,14,21,0),
#   duration: 261,
#   mode: "train"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Kings Cross",
#   destination: "Edinburgh Waverley",
#   cost: 69,
#   start_time: DateTime.new(2022,3,18,11,0,0),
#   end_time: DateTime.new(2022,3,18,15,22,0),
#   duration: 262,
#   mode: "train"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Kings Cross",
#   destination: "Edinburgh Waverley",
#   cost: 69,
#   start_time: DateTime.new(2022,3,18,11,30,0),
#   end_time: DateTime.new(2022,3,18,16,15,0),
#   duration: 285,
#   mode: "train"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Kings Cross",
#   destination: "Edinburgh Waverley",
#   cost: 76,
#   start_time: DateTime.new(2022,3,18,12,0,0),
#   end_time: DateTime.new(2022,3,18,16,42,0),
#   duration: 262,
#   mode: "train"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Kings Cross",
#   destination: "Edinburgh Waverley",
#   cost: 59,
#   start_time: DateTime.new(2022,3,18,12,18,0),
#   end_time: DateTime.new(2022,3,18,16,41,0),
#   duration: 263,
#   mode: "train"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Kings Cross",
#   destination: "Edinburgh Waverley",
#   cost: 196,
#   start_time: DateTime.new(2022,3,18,12,43,0),
#   end_time: DateTime.new(2022,3,18,18,21,0),
#   duration: 338,
#   mode: "train"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Kings Cross",
#   destination: "Edinburgh Waverley",
#   cost: 69,
#   start_time: DateTime.new(2022,3,18,13,0,0),
#   end_time: DateTime.new(2022,3,18,17,23,0),
#   duration: 263,
#   mode: "train"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Kings Cross",
#   destination: "Edinburgh Waverley",
#   cost: 69,
#   start_time: DateTime.new(2022,3,18,13,30,0),
#   end_time: DateTime.new(2022,3,18,18,16,0),
#   duration: 286,
#   mode: "train"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Kings Cross",
#   destination: "Edinburgh Waverley",
#   cost: 57.90,
#   start_time: DateTime.new(2022,3,18,14,36,0),
#   end_time: DateTime.new(2022,3,18,19,15,0),
#   duration: 279,
#   mode: "train"
# )
# puts "data added"

# FakeData.create!(
#   origin: "London Kings Cross",
#   destination: "Edinburgh Waverley",
#   cost: 69,
#   start_time: DateTime.new(2022,3,18,18,0,0),
#   end_time: DateTime.new(2022,3,18,22,19,0),
#   duration: 259,
#   mode: "train"
# )
# puts "data added"

# FakeData.create!(
#   origin: "N103TP",
#   destination: "EH200AA",
#   cost: 46.80,
#   start_time: DateTime.new(2022,3,18,12,0,0),
#   end_time: DateTime.new(2022,3,18,19,6,0),
#   duration: 426,
#   mode: "car"
# )
# puts "data added"

Parameter.create!(
  origin: "London",
<<<<<<< HEAD
  destination: "Leeds",
  preferred_start: DateTime.new(2022,3,18,12,0,0),
=======
  destination: "Nottingham",
  preferred_start: DateTime.new(2022,3,8,16,0,0),
>>>>>>> c50ad0580d270a632cd33225852b4f872c00eff5
  earliest_start: nil,
  latest_finish: nil,
)

# puts "parameter created"

# Parameter.create!(
#   origin: "Bristol",
#   destination: "Swansea",
#   preferred_start: DateTime.new(2022,3,14,11,20,0),
#   earliest_start: DateTime.new(2022,3,14,9,12,0),
#   latest_finish: DateTime.new(2022,3,14,19,5,0),
# )

# puts "parameter created"

# CityMapper API Attempt
# require 'open-uri'
# require 'json'
# url = 'https://api.external.citymapper.com/api'
# url_serialized = URI.open(url).read
# top_movies = JSON.parse(url_serialized)
# i = 0
# Movie.destroy_all
# while i < 20
#   puts 'Creating movie'
#   movie = Movie.new(title: top_movies['results'][i]['title'])
#   movie.save
#   puts movie.title
#   i += 1
# end
# puts 'Finished'
