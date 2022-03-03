class FakeDatasController < ApplicationController
  def create
  if current_user
    @parameter = Parameter.find_by(user_id: current_user.id)
  else
    @parameter = Parameter.last
  end

  cities = {
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

    origin_id = cities[@parameter.origin.downcase.to_sym]
    destination_id = cities[@parameter.destination.downcase.to_sym]

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

    preferred_start_date = "#{@parameter.preferred_start.year}-#{preferred_start_month}-#{preferred_start_day}"

    url = "https://uk.megabus.com/journey-planner/journeys?days=1&concessionCount=0&departureDate=#{preferred_start_date}&destinationId=#{destination_id}&inboundOtherDisabilityCount=0&inboundPcaCount=0&inboundWheelchairSeated=0&nusCount=0&originId=#{origin_id}&otherDisabilityCount=0&pcaCount=0&totalPassengers=1&wheelchairSeated=0"
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file, nil, "uft-8")

    document_json = JSON.parse(html_doc.search("script").last.text.scan(/{.*}/)[0])
    journeys = document_json["journeys"].map { |journey| [journey["departureDateTime"], journey["arrivalDateTime"], journey["duration"], journey["price"]] }

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
        origin: @parameter.origin,
        destination: @parameter.destination,
        cost: journey[3],
        start_time: DateTime.new(start_year, start_month, start_day, start_hour, start_minute, start_second),
        end_time: DateTime.new(end_year, end_month, end_day, end_hour, end_minute, end_second),
        duration: duration_mins,
        mode: "coach"
      )
    end
  end
end

    # if @parameter.preferred_start.time.hour < 10
    #   preferred_start_time = "0#{@parameter.preferred_start.time.hour}#{@parameter.preferred_start.time.min}"
    # else
    #   preferred_start_time = "#{@parameter.preferred_start.time.hour}#{@parameter.preferred_start.time.min}"
    # end

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
