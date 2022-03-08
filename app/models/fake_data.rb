class FakeData < ApplicationRecord
  has_many :bookings, dependent: :destroy

  def self.generate_results(parameter)


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

    preferred_start_date_bus = "#{parameter.preferred_start.year}-#{preferred_start_month}-#{preferred_start_day}"

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
      swansea: 97
    }

    origin_ids = bus_cities[parameter.origin.downcase.to_sym]
    destination_ids = bus_cities[parameter.destination.downcase.to_sym]

    url_bus = "https://uk.megabus.com/journey-planner/journeys?days=1&concessionCount=0&departureDate=#{preferred_start_date_bus}&destinationId=#{destination_ids}&inboundOtherDisabilityCount=0&inboundPcaCount=0&inboundWheelchairSeated=0&nusCount=0&originId=#{origin_ids}&otherDisabilityCount=0&pcaCount=0&totalPassengers=1&wheelchairSeated=0"
    html_file_bus = URI.open(url_bus).read
    html_doc_bus = Nokogiri::HTML(html_file_bus, nil, "uft-8")
    document_json_bus = JSON.parse(html_doc_bus.search("script").last.text.scan(/{.*}/)[0])

    if document_json_bus["journeys"] != nil
      journeys = document_json_bus["journeys"].map { |journey| [journey["departureDateTime"], journey["arrivalDateTime"], journey["duration"], journey["price"], journey["origin"]["cityName"], journey["origin"]["stopName"], journey["destination"]["cityName"], journey["destination"]["stopName"]] }

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

        FakeData.create!(
          origin: "#{journey[4]} #{journey[5]}",
          destination: "#{journey[6]} #{journey[7]}",
          cost: journey[3],
          start_time: DateTime.new(start_year, start_month, start_day, start_hour, start_minute, start_second),
          end_time: DateTime.new(end_year, end_month, end_day, end_hour, end_minute, end_second),
          duration: duration_mins,
          mode: "bus"
        )
      end
    end

    if parameter.earliest_start.nil?
      earliest_start_date_train = parameter.preferred_start - 14400
    else
      earliest_start_date_train = parameter.earliest_start
    end

    if parameter.latest_finish.nil?
      latest_finish_date_train = parameter.preferred_start + 28800
    else
      latest_finish_date_train = parameter.latest_finish
    end

    # parameter = Parameter.last # testing

    if earliest_start_date_train.time.min < 10
      earliest_start_min = "0#{earliest_start_date_train.time.min}"
    else
      earliest_start_min = "#{earliest_start_date_train.time.min}"
    end

    while FakeData.all.count.zero? || (FakeData.last.end_time < latest_finish_date_train) || FakeData.last.mode == 'bus'


      train_cities = {
        birmingham: "Birmingham",
        bristol: "Bristol",
        cardiff: "Cardiff",
        coventry: "COV",
        edinburgh: "EDB",
        exeter: "Exeter",
        glasgow: "Glasgow",
        leeds: "LDS",
        leicester: "LEI",
        livepool: "Liverpool",
        london: "London",
        manchester: "Manchester",
        newcastle: "NCL",
        nottingham: "NOT",
        sheffield: "SHF",
        swansea: "SWA"
      }

      origin_ids = train_cities[parameter.origin.downcase.to_sym]
      destination_ids = train_cities[parameter.destination.downcase.to_sym]

      if earliest_start_date_train.time.hour < 10
        earliest_start_hour = "0#{earliest_start_date_train.time.hour}"
      else
        earliest_start_hour = "#{earliest_start_date_train.time.hour}"
      end

      earliest_start_time = "#{earliest_start_hour}#{earliest_start_min}"

      if earliest_start_date_train.month < 10
        earliest_start_month = "0#{earliest_start_date_train.month}"
      else
        earliest_start_month = earliest_start_date_train.month.to_s
      end

      if earliest_start_date_train.day < 10
        earliest_start_day = "0#{earliest_start_date_train.day}"
      else
        earliest_start_day = earliest_start_date_train.day.to_s
      end

      earliest_start_year_train = earliest_start_date_train.year.to_s[2..-1]

      earliest_start_date_train_string = "#{earliest_start_day}#{earliest_start_month}#{earliest_start_year_train}"

      url_train = "https://ojp.nationalrail.co.uk/service/timesandfares/#{origin_ids}/#{destination_ids}/#{earliest_start_date_train_string}/#{earliest_start_time}/dep"

      html_file_train = URI.open(url_train).read
      html_doc_train = Nokogiri::HTML(html_file_train, nil, "uft-8")

      origin_stations_train = []
      destination_stations_train = []
      if html_doc_train.css(".result-station") != nil
        html_doc_train.css(".result-station").each_with_index do |station, index|
          if index.even?
            origin_stations_train << station.text
          else
            destination_stations_train << station.text
          end
        end

        departures_train = []
        arrivals_train = []
        durations_train = []
        prices_train = []

        html_doc_train.css("td .dep").each do |departure|
          departures_train << departure.text.gsub("\n", '').gsub("\t", '')
        end

        html_doc_train.css("td .arr").each do |arrival|
          arrivals_train << arrival.text.gsub("\n", '').gsub("\t", '')
        end

        html_doc_train.css("td .dur").each do |duration|
          durations_train << duration.text.gsub("\n", '').gsub("\t", '')
        end

        html_doc_train.css("td .opsingle").each do |price|
          prices_train << price.text.gsub("\n", '').gsub("\t", '').gsub('£', '').to_f
        end

        break if departures_train.length == 0

        for i in 1..departures_train.length
          earliest_start_day = (earliest_start_day.to_i + 1).to_s if (FakeData.all.count != 0) && (arrivals_train[i-1].split(':')[0].to_i < FakeData.last.end_time.hour) && ((arrivals_train[i-1].split(':')[0].to_i - FakeData.last.end_time.hour).abs > 10) && (FakeData.last.mode != "bus")

          FakeData.create!(
            origin: origin_stations_train[i-1],
            destination: destination_stations_train[i-1],
            cost: prices_train[i-1],
            start_time: DateTime.new(earliest_start_date_train.year, earliest_start_month.to_i, earliest_start_day.to_i, departures_train[i-1].split(':')[0].to_i, departures_train[i-1].split(':')[1].to_i, 0),
            end_time: DateTime.new(earliest_start_date_train.year, earliest_start_month.to_i, earliest_start_day.to_i, arrivals_train[i-1].split(':')[0].to_i, arrivals_train[i-1].split(':')[1].to_i, 0),
            duration: (durations_train[i-1][0..-2].split('h').first.to_i * 60) + (durations_train[i-1][0..-2].split('h').last.to_i),
            mode: "train"
          )
          puts "created train journey"
        end
      end
      Parameter.create(
        origin: parameter.origin,
        destination: parameter.destination,
        preferred_start: parameter.preferred_start,
        earliest_start: FakeData.last.start_time,
        latest_finish: latest_finish_date_train
      )

      parameter = Parameter.last
      earliest_start_date_train = FakeData.last.start_time + 360
    end
  end
end
