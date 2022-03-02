require "open-uri"
require "nokogiri"

class FakeDatasController < ApplicationController
  def create
    @parameter = Parameter.last

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
      swansea: 97,
    }

    origin_id = cities[@parameter.origin.downcase]
    destination_id = cities[@parameter.destination.downcase]

    if @parameter.preferred_start.time.hour < 10
      preferred_start_time = "0#{@parameter.preferred_start.time.hour}#{@parameter.preferred_start.time.min}"
    else
      preferred_start_time = "#{@parameter.preferred_start.time.hour}#{@parameter.preferred_start.time.min}"
    end

    preferred_start_date = "#{@parameter.preferred_start.year}-#{@parameter.preferred_start.month}-#{@parameter.preferred_start.day}"

    def split_start_time(i, j)
      split_start = @start_times[i].split(":")
      split_start[j].to_i
    end

    def split_end_time(i, j)
      split_end = @end_times[i].split(":")
      split_end[j].to_i
    end

    def split_start_date(i, j)
      split_start = @start_dates[i].split("-")
      split_start[j].to_i
    end

    def split_end_date(i, j)
      split_end = @end_dates[i].split("-")
      split_end[j].to_i
    end

    def split_duration(i, j)
      split_duration = @durations[i].split("H")
      split_duration[j].to_i
    end

    url = "https://uk.megabus.com/journey-planner/journeys?days=1&concessionCount=0&departureDate=#{preferred_start_date}&destinationId=#{destination_id}&inboundOtherDisabilityCount=0&inboundPcaCount=0&inboundWheelchairSeated=0&nusCount=0&originId=#{origin_id}&otherDisabilityCount=0&pcaCount=0&totalPassengers=1&wheelchairSeated=0"
    html_file = URI.open(url, :allow_redirections => :all).read
    html_doc = Nokogiri::HTML(html_file, nil, "uft-8")

    prices = html_doc.search("script").last.text.scan(/\d{1,2}\.\d{2}/)
    @start_times = html_doc.search("script").last.text.scan(/\d{2}:\d{2}:\d{2}/).reject!.with_index{|time, i| i.odd?}.reject!.with_index{|time, i| i.odd?}
    @end_times = html_doc.search("script").last.text.scan(/\d{2}:\d{2}:\d{2}/).reject!.with_index{|time, i| i.even?}.reject!.with_index{|time, i| i.even?}
    @start_dates = html_doc.search("script").last.text.scan(/\d{4}-\d{2}-\d{2}/).reject!.with_index{|time, i| i.odd?}.reject!.with_index{|time, i| i.odd?}
    @end_dates = html_doc.search("script").last.text.scan(/\d{4}-\d{2}-\d{2}/).reject!.with_index{|time, i| i.even?}.reject!.with_index{|time, i| i.even?}
    @durations = html_doc.search("script").last.text.scan(/\d{1,2}H\d{1,2}/).reject!.with_index{|time, i| i.odd?}

    for i in 1..prices.length do
      FakeData.create!(
        origin: origin,
        destination: destination,
        cost: prices[i].to_i,
        start_time: DateTime.new(split_start_date(i, 0),split_start_date(i, 1),split_start_date(i, 2),split_start_time(i, 0),split_start_time(i, 1),split_start_time(i, 2)),
        end_time: DateTime.new(split_end_date(i, 0),split_end_date(i, 1),split_end_date(i, 2),split_end_time(i, 0),split_end_time(i, 1),split_end_time(i, 2)),
        duration: ((split_duration(i, 0) * 60) + split_duration(i, 1)),
        mode: "coach"
      )
    end
  end
end
