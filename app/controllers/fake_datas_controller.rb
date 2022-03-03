class FakeDatasController < ApplicationController
  def create
  # if current_user
  #   @parameter = Parameter.find_by(user_id: current_user.id)
  # else
    @parameter = Parameter.last
  # end

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
    livepool: 54,
    london: 56,
    manchester: 58,
    newcastle: 63,
    nottingham: 68,
    sheffield: 90,
    swansea: 97
  }

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

    origin_ids = [bus_cities[@parameter.origin.downcase.to_sym], train_cities[@parameter.origin.downcase.to_sym]]
    destination_ids = [bus_cities[@parameter.destination.downcase.to_sym], train_cities[@parameter.destination.downcase.to_sym]]

    if @parameter.preferred_start.time.hour < 10
      preferred_start_hour = "0#{@parameter.preferred_start.time.hour}"
    else
      preferred_start_hour = "#{@parameter.preferred_start.time.hour}"
    end

    if @parameter.preferred_start.time.min < 10
      preferred_start_min = "0#{@parameter.preferred_start.time.min}"
    else
      preferred_start_min = "#{@parameter.preferred_start.time.min}"
    end

    preferred_start_time = "#{preferred_start_hour}#{preferred_start_min}"

    if @parameter.preferred_start.month < 10
      preferred_start_month = "0#{@parameter.preferred_start.month}"
    else
      preferred_start_month = @parameter.preferred_start.month.to_s
    end

    if @parameter.preferred_start.day < 10
      preferred_start_day = "0#{@parameter.preferred_start.day}"
    else
      preferred_start_day = @parameter.preferred_start.day.to_s
    end

    preferred_start_year_train = @parameter.preferred_start.year.to_s[2..-1]

    preferred_start_date_bus = "#{@parameter.preferred_start.year}-#{preferred_start_month}-#{preferred_start_day}"
    preferred_start_date_train = "#{preferred_start_day}#{preferred_start_month}#{preferred_start_year_train}"

    url_bus = "https://uk.megabus.com/journey-planner/journeys?days=1&concessionCount=0&departureDate=#{preferred_start_date_bus}&destinationId=#{destination_ids[0]}&inboundOtherDisabilityCount=0&inboundPcaCount=0&inboundWheelchairSeated=0&nusCount=0&originId=#{origin_ids[0]}&otherDisabilityCount=0&pcaCount=0&totalPassengers=1&wheelchairSeated=0"
    url_train = "https://ojp.nationalrail.co.uk/service/timesandfares/#{origin_ids[1]}/#{destination_ids[1]}/#{preferred_start_date_train}/#{preferred_start_time}/dep"

    html_file_bus = URI.open(url_bus).read
    html_file_train = URI.open(url_train).read
    html_doc_bus = Nokogiri::HTML(html_file_bus, nil, "uft-8")
    html_doc_train = Nokogiri::HTML(html_file_train, nil, "uft-8")
    document_json_bus = JSON.parse(html_doc_bus.search("script").last.text.scan(/{.*}/)[0])
    # document_json_train = JSON.parse(html_doc_train.search("script").last.text.scan(/{.*}/)[0])

    origin_stations_train = []
    destination_stations_train = []
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
      prices_train << price.text.gsub("\n", '').gsub("\t", '')
    end

    journeys = document_json_bus["journeys"].map { |journey| [journey["departureDateTime"], journey["arrivalDateTime"], journey["duration"], journey["price"], journey["origin"]["cityName"], journey["origin"]["stopName"], journey["destination"]["cityName"], journey["destination"]["stopName"]] }

    journeys.each do |journey|
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

      duration_array = journey[2].scan(/\d{1,2}H\d{1,2}/)[0].split('H')
      duration_mins = (duration_array[0].to_i * 60) + (duration_array[1].to_i)

      FakeData.create!(
        origin: "#{journey[4]} #{journey[5]}",
        destination: "#{journey[6]} #{journey[7]}",
        cost: journey[3],
        start_time: DateTime.new(start_year, start_month, start_day, start_hour, start_minute, start_second),
        end_time: DateTime.new(end_year, end_month, end_day, end_hour, end_minute, end_second),
        duration: duration_mins,
        mode: "coach"
      )
      puts "created Bus Journey"
    end
    for i in 1..departures_train.length
      FakeData.create!(
        origin: origin_stations_train[i-1],
        destination: destination_stations_train[i-1],
        cost: prices_train[i-1].gsub('£', '').to_f,
        start_time: DateTime.new(@parameter.preferred_start.year, preferred_start_month.to_i, preferred_start_day.to_i, departures_train[i-1].split(':')[0].to_i, departures_train[i-1].split(':')[1].to_i, 0),
        end_time: DateTime.new(@parameter.preferred_start.year, preferred_start_month.to_i, preferred_start_day.to_i, arrivals_train[i-1].split(':')[0].to_i, arrivals_train[i-1].split(':')[1].to_i, 0),
        duration: (durations_train[i-1][0..-2].split('h').first.to_i * 60) + (durations_train[i-1][0..-2].split('h').last.to_i),
        mode: "train"
      )
      puts "created Train Journey"
    end
  end
end

    # def split_start_time(i, j)
    #   split_start = @start_times[i].split(":")
    #   split_start[j].to_i
    # end

    # def split_end_time(i, j)
    #   split_end = @end_times[i].split(":")
    #   split_end[j].to_i
    # end

    # def split_start_date(i, j)
    #   split_start = @start_dates[i].split("-")
    #   split_start[j].to_i
    # end

    # def split_end_date(i, j)
    #   split_end = @end_dates[i].split("-")
    #   split_end[j].to_i
    # end

    # def split_duration(i, j)
    #   split_duration = @durations[i].split("H")
    #   split_duration[j].to_i
    # end

        # prices = html_doc.search("script").last.text.scan(/\d{1,2}\.\d{2}/)
    # @start_times = html_doc.search("script").last.text.scan(/\d{2}:\d{2}:\d{2}/).reject!.with_index{|time, i| i.odd?}.reject!.with_index{|time, i| i.odd?}
    # @end_times = html_doc.search("script").last.text.scan(/\d{2}:\d{2}:\d{2}/).reject!.with_index{|time, i| i.even?}.reject!.with_index{|time, i| i.even?}
    # @start_dates = html_doc.search("script").last.text.scan(/\d{4}-\d{2}-\d{2}/).reject!.with_index{|time, i| i.odd?}.reject!.with_index{|time, i| i.odd?}
    # @end_dates = html_doc.search("script").last.text.scan(/\d{4}-\d{2}-\d{2}/).reject!.with_index{|time, i| i.even?}.reject!.with_index{|time, i| i.even?}
    # @durations = html_doc.search("script").last.text.scan(/\d{1,2}H\d{1,2}/).reject!.with_index{|time, i| i.odd?}

    # journeys.each do |journey|
    #   FakeData.create!(
    #     origin: @parameter.origin,
    #     destination: @parameter.destination,
    #     cost: journey[3],
    #     start_time: DateTime.new(split_start_date(i, 0), split_start_date(i, 1), split_start_date(i, 2), split_start_time(i, 0), split_start_time(i, 1), split_start_time(i, 2)),
    #     end_time: DateTime.new(split_end_date(i, 0), split_end_date(i, 1), split_end_date(i, 2), split_end_time(i, 0), split_end_time(i, 1), split_end_time(i, 2)),
    #     duration: ((split_duration(i, 0) * 60) + split_duration(i, 1)),
    #     mode: "coach"
    #   )
    # end
