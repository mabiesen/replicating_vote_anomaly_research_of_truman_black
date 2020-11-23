require 'json'
require 'date'

class StateEdisonData
  attr_accessor :state_json_data, :state_name
  
  def initialize(filepath)
    @state_name = File.basename(filepath, '.*').upcase
    puts "EVALUATING #{@state_name}"
    puts ""
    state_json_data(filepath)
  end

  def state_json_data(filepath)
    @state_json_data ||= JSON.parse(File.read(filepath))
  end

  def time_series_data_from_json_data(json_data)
    json_data["data"]["races"][0]["timeseries"]
  end

  def print_times_where_total_vote_count_dropped(timeseries_array)
    timeseries_array.each_with_index do |tsdata, index|
      next if index == 0

      current_votes = tsdata['votes']
      current_timestamp = tsdata['timestamp']
      last_votes = timeseries_array[index - 1]['votes']
      last_timestamp = timeseries_array[index - 1]['timestamp']
      if tsdata['votes'] < timeseries_array[index - 1]['votes']
        puts "total count dropped by #{current_votes - last_votes} between #{last_timestamp} and #{current_timestamp}"
      end
    end
    puts "\n\n"
  end

  def print_times_where_lead_switched(timeseries_array)
    timeseries_array.each_with_index do |tsdata, index|
      next if index == 0
      
      trump_key = 'trumpd'
      biden_key = 'bidenj'
      current_lead = tsdata['vote_shares'][trump_key] > tsdata['vote_shares'][biden_key] ? 'Trump' : 'Biden' 
      last_tsdata  = timeseries_array[index - 1]
      last_lead = last_tsdata['vote_shares'][trump_key] > last_tsdata['vote_shares'][biden_key] ? 'Trump' : 'Biden'

      if last_lead != current_lead
        puts "Lead switched in #{current_lead}'s favor at #{tsdata['timestamp']}"
      end
    end
    puts "\n\n"
  end
end

def convert_timestamp_to_datetime(timestamp)
  date_and_time = '%Y-%m-%dT%H:%M:%S'
  DateTime.strptime(timestamp ,date_and_time)
end


puts "Please supply the filepath for the state you wish to examine"
state_filepath = gets.chomp

# instantiate edidson state data class
sed = StateEdisonData.new(state_filepath) 

# getting the data
json_data = sed.state_json_data(state_filepath)
timeseries_data = sed.time_series_data_from_json_data(json_data)

# converting timestamps to insure proper sort
timeseries_data = timeseries_data.map do |tsdata|
                    tsdata['timestamp'] = convert_timestamp_to_datetime(tsdata['timestamp'])
                    tsdata
                  end

# sort data by timestamp
timeseries_data = timeseries_data.sort_by do |tsdata|
                    tsdata['timestamp']
                  end

puts "Printing times where the total vote count dropped"
sed.print_times_where_total_vote_count_dropped(timeseries_data)

puts "Printing times where the lead switched"
sed.print_times_where_lead_switched(timeseries_data)
