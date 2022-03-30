class Result < ApplicationRecord
  has_many :bookings, dependent: :destroy
  monetize :price_cents

  def self.generate_results(parameter)
    bus_results(parameter)
    train_results(parameter)
  end

  def self.bus_results(parameter)
    set_bus_date(parameter)
    set_bus_url(parameter)
    get_bus_data
    get_bus_journeys
  end

  def self.train_results(parameter)
    earliest_start_train(parameter)

    @latest_finish_date_train = 0
    @current_journeys = Result.where('booked != true')

    while @current_journeys.count.zero? || (parameter.latest_finish != nil) && (@current_journeys.last.end_time < parameter.latest_finish) || @current_journeys.last.mode == 'bus' || @latest_finish_date_train == 0

      train_route_ids(parameter)
      train_date_time
      train_data

      if @html_doc_train.css(".result-station") != nil
        train_stations
        train_journey_info
        break if @departures_train.length.zero?
        @current_journeys = Result.where('booked != true')

        @departure_day = Result.last.start_time.day if @current_journeys.count != 0 && @current_journeys.last.mode != 'bus'

        make_train_results
      end

      break if @departures_train.length.zero?

      train_latest_finish_default(parameter)
      new_parameter(parameter)

      parameter = Parameter.last
      @earliest_start_date_train = Result.last.start_time + 360
    end
  end

  def self.set_bus_date(parameter)
    if parameter.preferred_start.month < 10
      preferred_start_month = "0#{parameter.preferred_start.month}"
    else
      preferred_start_month = parameter.preferred_start.month.to_s
    end

    if parameter.preferred_start.day < 10
      preferred_start_day = "0#{parameter.preferred_start.day}"
    else
      preferred_start_day = parameter.preferred_start.day.to_s
    end

    @preferred_start_date_bus = "#{parameter.preferred_start.year}-#{preferred_start_month}-#{preferred_start_day}"
  end

  def self.set_bus_url(parameter)
    bus_cities = {
      birmingham: 8,
      bristol: 13,
      cardiff: 20,
      coventry: 27,
      edinburgh: 34,
      exeter: 36,
      glasgow: 38,
      leeds: 52,
      leicester: 53,
      liverpool: 54,
      london: 56,
      manchester: 58,
      newcastle: 63,
      nottingham: 68,
      sheffield: 90,
      sunderland: 96,
      swansea: 97
    }

    origin_check = parameter.origin
    if origin_check == "Newcastle upon Tyne"
      origin_check = "Newcastle"
    end

    dest_check = parameter.destination
    if dest_check == "Newcastle upon Tyne"
      dest_check = "Newcastle"
    end

    @origin_id = bus_cities[origin_check.downcase.to_sym]
    @destination_id = bus_cities[dest_check.downcase.to_sym]
  end

  def self.get_bus_data
    url_bus = "https://uk.megabus.com/journey-planner/journeys?days=1&concessionCount=0&departureDate=#{@preferred_start_date_bus}&destinationId=#{@destination_id}&inboundOtherDisabilityCount=0&inboundPcaCount=0&inboundWheelchairSeated=0&nusCount=0&originId=#{@origin_id}&otherDisabilityCount=0&pcaCount=0&totalPassengers=1&wheelchairSeated=0"
    html_file_bus = URI.open(url_bus).read
    html_doc_bus = Nokogiri::HTML(html_file_bus, nil, "uft-8")
    @document_json_bus = JSON.parse(html_doc_bus.search("script").last.text.scan(/{.*}/)[0])
  end

  def self.get_bus_journeys
    if @document_json_bus["journeys"] != nil
      journeys = @document_json_bus["journeys"].map { |journey| [journey["departureDateTime"], journey["arrivalDateTime"], journey["duration"], journey["price"], journey["origin"]["cityName"], journey["origin"]["stopName"], journey["destination"]["cityName"], journey["destination"]["stopName"]] }

      journeys.reverse_each do |journey|
        start_year = journey[0].split('T').first.split('-')[0].to_i
        start_month = journey[0].split('T').first.split('-')[1].to_i
        start_day = journey[0].split('T').first.split('-')[2].to_i
        start_hour = journey[0].split('T').last.split(':')[0].to_i
        start_minute = journey[0].split('T').last.split(':')[1].to_i
        start_second = journey[0].split('T').last.split(':')[2].to_i

        end_year = journey[1].split('T').first.split('-')[0].to_i
        end_month = journey[1].split('T').first.split('-')[1].to_i
        end_day = journey[1].split('T').first.split('-')[2].to_i
        end_hour = journey[1].split('T').last.split(':')[0].to_i
        end_minute = journey[1].split('T').last.split(':')[1].to_i
        end_second = journey[1].split('T').last.split(':')[2].to_i

        if journey[2].scan(/\d{1,2}H\d{1,2}/)[0]
          duration_array = journey[2].scan(/\d{1,2}H\d{1,2}/)[0].split('H')
          duration_mins = (duration_array[0].to_i * 60) + (duration_array[1].to_i)
        elsif journey[2].scan(/PT\d{1,2}M/)[0]
          duration_mins = journey[2].scan(/PT\d{1,2}M/)[0][2..-1].to_i
        else
          duration_array = journey[2].scan(/\d{1,2}H/)[0][0..-2]
          duration_mins = (duration_array.to_i * 60)
        end

        Result.create!(
          origin: "#{journey[4]} #{journey[5]}",
          destination: "#{journey[6]} #{journey[7]}",
          price_cents: (journey[3] * 100),
          start_time: DateTime.new(start_year, start_month, start_day, start_hour, start_minute, start_second),
          end_time: DateTime.new(end_year, end_month, end_day, end_hour, end_minute, end_second),
          duration: duration_mins,
          mode: "bus"
        )
      end
    end
  end

  def self.earliest_start_train(parameter)
    if parameter.earliest_start.nil?
      if parameter.preferred_start < DateTime.now
        @earliest_start_date_train = parameter.preferred_start
      elsif parameter.preferred_start - 14400 < DateTime.now
        @earliest_start_date_train = DateTime.now
      else
        @earliest_start_date_train = parameter.preferred_start - 14400
      end
    else
      @earliest_start_date_train = parameter.earliest_start
    end
  end

  def self.train_route_ids(parameter)
    train_cities = {
      birmingham: "Birmingham",
      bath: "BTH",
      bristol: "Bristol",
      cardiff: "Cardiff",
      coventry: "COV",
      edinburgh: "EDB",
      exeter: "Exeter",
      glasgow: "Glasgow",
      leeds: "LDS",
      leicester: "LEI",
      liverpool: "Liverpool",
      london: "London",
      manchester: "Manchester",
      newcastle: "NCL",
      nottingham: "NOT",
      sheffield: "SHF",
      swansea: "SWA"
    }

    origin_check = parameter.origin
    if origin_check == "Newcastle upon Tyne"
      origin_check = "Newcastle"
    end

    dest_check = parameter.destination
    if dest_check == "Newcastle upon Tyne"
      dest_check = "Newcastle"
    end

    @origin_id = train_cities[origin_check.downcase.to_sym]
    @destination_id = train_cities[dest_check.downcase.to_sym]
  end

  def self.train_date_time
    if @earliest_start_date_train.hour < 10
      earliest_start_hour = "0#{@earliest_start_date_train.hour}"
    else
      earliest_start_hour = "#{@earliest_start_date_train.hour}"
    end

    if @earliest_start_date_train.min < 10
      earliest_start_min = "0#{@earliest_start_date_train.min}"
    else
      earliest_start_min = "#{@earliest_start_date_train.min}"
    end

    @earliest_start_time = "#{earliest_start_hour}#{earliest_start_min}"

    if @earliest_start_date_train.month < 10
      @earliest_start_month = "0#{@earliest_start_date_train.month}"
    else
      @earliest_start_month = @earliest_start_date_train.month.to_s
    end

    if @earliest_start_date_train.day < 10
      @earliest_start_day = "0#{@earliest_start_date_train.day}"
    else
      @earliest_start_day = @earliest_start_date_train.day.to_s
    end

    @arrival_day = @departure_day = @earliest_start_day

    earliest_start_year_train = @earliest_start_date_train.year.to_s[2..-1]

    @earliest_start_date_train_string = "#{@earliest_start_day}#{@earliest_start_month}#{earliest_start_year_train}"
  end

  def self.train_data
    url_train = "https://ojp.nationalrail.co.uk/service/timesandfares/#{@origin_id}/#{@destination_id}/#{@earliest_start_date_train_string}/#{@earliest_start_time}/dep"

    html_file_train = URI.open(url_train).read
    @html_doc_train = Nokogiri::HTML(html_file_train, nil, "uft-8")

    @origin_stations_train = []
    @destination_stations_train = []
  end

  def self.train_stations
    @html_doc_train.css(".result-station").each_with_index do |station, index|
      if index.even?
        @origin_stations_train << station.text
      else
        @destination_stations_train << station.text
      end
    end
  end

  def self.train_journey_info
    @departures_train = []
    @arrivals_train = []
    @durations_train = []
    @prices_train = []

    @html_doc_train.css("td .dep").each do |departure|
      @departures_train << departure.text.gsub("\n", '').gsub("\t", '')
    end

    @html_doc_train.css("td .arr").each do |arrival|
      @arrivals_train << arrival.text.gsub("\n", '').gsub("\t", '')
    end

    @html_doc_train.css("td .dur").each do |duration|
      @durations_train << duration.text.gsub("\n", '').gsub("\t", '')
    end

    @html_doc_train.css("td .opsingle").each do |price|
      @prices_train << price.text.gsub("\n", '').gsub("\t", '').gsub('£', '').to_f
    end
  end

  def self.make_train_results
    for i in 1..@departures_train.length
      @arrival_day = (@earliest_start_day.to_i + 1).to_s if (@current_journeys.count != 0) && (@arrivals_train[i-1].split(':')[0].to_i < @current_journeys.last.end_time.hour) && ((@arrivals_train[i-1].split(':')[0].to_i - @current_journeys.last.end_time.hour).abs > 10) && (@current_journeys.last.mode != "bus")
      @departure_day = (@earliest_start_day.to_i + 1).to_s if (@current_journeys.count != 0) && (@departures_train[i-1].split(':')[0].to_i < @current_journeys.last.start_time.hour) && ((@departures_train[i-1].split(':')[0].to_i - @current_journeys.last.start_time.hour).abs > 10) && (@current_journeys.last.mode != "bus")
      @arrival_day = (@arrival_day.to_i + 1).to_s if @arrival_day.to_i < @departure_day.to_i

      Result.create!(
        origin: @origin_stations_train[i - 1],
        destination: @destination_stations_train[i - 1],
        price_cents: ((@prices_train[i - 1].to_f) * 100).to_i,
        start_time: DateTime.new(@earliest_start_date_train.year, @earliest_start_month.to_i, @departure_day.to_i, @departures_train[i-1].split(':')[0].to_i, @departures_train[i-1].split(':')[1].to_i, 0),
        end_time: DateTime.new(@earliest_start_date_train.year, @earliest_start_month.to_i, @arrival_day.to_i, @arrivals_train[i-1].split(':')[0].to_i, @arrivals_train[i-1].split(':')[1].to_i, 0),
        duration: (@durations_train[i-1][0..-2].split('h').first.to_i * 60) + (@durations_train[i-1][0..-2].split('h').last.to_i),
        mode: "train"
      )
      if ((Result.last.duration) > 1200)
        Result.last.update(duration: (Result.last.end_time - Result.last.start_time) / 60)
      end

      puts "created train journey"
    end
  end

  def self.train_latest_finish_default(parameter)
    if parameter.latest_finish.nil?
      first_train_journey = @current_journeys.select { |journey| journey[:mode] == 'train' }.first
      @latest_finish_date_train = first_train_journey.start_time + (120 * first_train_journey.duration) + 7200
    else
      @latest_finish_date_train = parameter.latest_finish
    end
  end

  def self.new_parameter(parameter)
    Parameter.create(
      origin: parameter.origin,
      destination: parameter.destination,
      preferred_start: parameter.preferred_start,
      earliest_start: Result.last.start_time,
      latest_finish: @latest_finish_date_train
    )
  end
end
