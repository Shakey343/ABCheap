FakeData.create!(
  origin: "London Victoria Coach Station",
  destination: "Leeds City Bus Station, Stand 1",
  price_cents: 790,
  start_time: DateTime.new(2022,3,18,15,0,0),
  end_time: DateTime.new(2022,3,18,19,45,0),
  duration: 285,
  mode: "bus"
)
puts "data added"

FakeData.create!(
  origin: "London Victoria Coach Station",
  destination: "Leeds City Bus Station, Stand 1",
  price_cents: 1090,
  start_time: DateTime.new(2022,3,18,13,10,0),
  end_time: DateTime.new(2022,3,19,18,0,0),
  duration: 290,
  mode: "bus"
)
puts "data added"

FakeData.create!(
  origin: "London Victoria Coach Station",
  destination: "Leeds City Bus Station, Stand 1",
  price_cents: 950,
  start_time: DateTime.new(2022,3,18,16,0,0),
  end_time: DateTime.new(2022,3,18,21,0,0),
  duration: 300,
  mode: "bus"
)
puts "data added"


FakeData.create!(
  origin: "London Kings Cross",
  destination: "Leeds",
  price_cents: 5099,
  start_time: DateTime.new(2022,3,18,14,10,0),
  end_time: DateTime.new(2022,3,18,16,10,0),
  duration: 120,
  mode: "train"
)
puts "data added"

FakeData.create!(
  origin: "London Kings Cross",
  destination: "Leeds",
  price_cents: 2550,
  start_time: DateTime.new(2022,3,18,13,10,0),
  end_time: DateTime.new(2022,3,18,15,25,0),
  duration: 135,
  mode: "train"
)
puts "data added"

FakeData.create!(
  origin: "London",
  destination: "Leeds",
  price_cents: 4000,
  start_time: DateTime.new(2022,3,18,14,1,0),
  end_time: DateTime.new(2022,3,18,18,4,0),
  duration: 245,
  mode: "car"
)
puts "data added"

FakeData.create!(
  origin: "London",
  destination: "Manchester",
  price_cents: 1130,
  start_time: DateTime.new(2022,3,14,12,0,0),
  end_time: DateTime.new(2022,3,14,16,45,0),
  duration: 285,
  mode: "bus"
)
puts "data added"

FakeData.create!(
  origin: "London",
  destination: "Edinburgh",
  price_cents: 3020,
  start_time: DateTime.new(2022,1,20,9,25,0),
  end_time: DateTime.new(2022,1,20,14,35,0),
  duration: 310,
  mode: "train"
)
puts "data added"
