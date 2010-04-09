require 'open-uri'
require 'pp'

BASE_URL='http://www.bctransit.com/regions/vic/'

def fetchroute number, direction, day
	url = "#{BASE_URL}schedules/schedule.cfm?p=dir.text&route=#{number}:#{direction}&day=#{day}"
  puts url

	line = Nokogiri::HTML(open(url))

  begin
    table = line.at_css('.scheduletable')

    points = table.css('tr').detect do |x|
      x.at_css('.css-sched-waypoints')
    end.css('td:nth-child(even)').map(&:inner_text)

    rows = table.css('tr').select do |x|
      x.at_css('.css-sched-waypoints').nil? and x.at_css('.css-sched-table-title').nil?
    end
  rescue
    return
  end

	lasttimes = [0]*points.length
	offsets = [0]*points.length

  trips = []
  rows.map do |t|
    times = []
    t.css('td:nth-child(even)').each_with_index do |stime, i|
      if stime.inner_text =~ /([0-9][0-9]?):([0-9][0-9])/
        time = ($1 == "12" ? 0 : $1.to_i) * 60 + $2.to_i

        # silly way to autodetect change from AM to PM
        offsets[i] = 12*60 if time < lasttimes[i]
        time += offsets[i]
        lasttimes[i] = time

        times << time
      end
    end
    trips << times
  end
  return [day, direction, points, trips]
end

def fetchline lineno, name
	puts "fetching line #{lineno} - #{name}"
  list = []
	for direction in [0,1] do
		for day in [1,6,7] do
      list << fetchroute(lineno, direction, day)
		end
	end
  [lineno, name, list.compact]
end

def build results
  results.each do |a|
    number,name,list = a[0]
    puts "writing line #{number} - #{name}"
    route = Route.create(:number=>number, :name=>name)
    list.each do |day, direction, stops, trips|
      stops.map! { |x| Stop.get_by_name(x) }
      trips.each do |times|
        trip = Trip.create(:route=>route, :day=>day, :direction=>direction)
        times.each_with_index do |time, i|
          ScheduleTime.create(:trip=>trip, :stop=>stops[i], :time=>time)
        end
      end
    end
  end
end

task :scrape => :environment do
  index = Nokogiri::HTML(open(BASE_URL))

  lines = index.css('#dvSchedule a').map do |item|
    if item[:href] =~ /\/regions\/vic\/schedules\/schedule\.cfm\?line=(\d+)&/
      [$1, item.inner_text]
    end
  end.uniq.compact
  results = Parallel.map(lines, :in_threads=>10){ |lineno, name| fetchline(lineno, name) }
  
  puts "Adding to database..."
  ActiveRecord::Base.transaction do
    build results
  end
end

