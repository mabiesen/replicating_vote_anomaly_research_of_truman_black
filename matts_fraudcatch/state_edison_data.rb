require 'json'
require 'date'

class StateEdisonData
  attr_reader :state_json_data, :state_name
  attr_reader :total_vote_count_drop, :biden_total_drop, :trump_total_drop
  
  def initialize(filepath)
    @state_name = File.basename(filepath, '.*').upcase
    state_json_data(filepath)
    total_vote_count_drop
    @biden_total_drop = vote_drop_total_for_candidate('Biden')
    @trump_total_drop = vote_drop_total_for_candidate('Trump')
  end

  def did_total_vote_count_drop?
    return true if @total_vote_count_drop < 0

    false
  end

  def did_biden_vote_count_drop?
    return true if @biden_total_drop < 0

    false
  end

  def did_trump_vote_count_drop?
    return true if @trump_total_drop < 0

    false
  end

  def biden_drop_more_than_trump?
    return true if @biden_total_drop < @trump_total_drop

    false
  end

  def state_json_data(filepath)
    return @state_json_data unless @state_json_data.nil? 

    json_data = JSON.parse(File.read(filepath))
    @state_json_data = convert_time_series_timestamp_to_datetime(json_data)
  end

  def convert_time_series_timestamp_to_datetime(json_data)
    timeseries_data = json_data["data"]["races"][0]["timeseries"]
    date_and_time = '%Y-%m-%dT%H:%M:%S'
    new_timeseries = timeseries_data.map do |tsdata|
                       tsdata['timestamp'] = DateTime.strptime(tsdata['timestamp'], date_and_time)
                       tsdata
                     end
    new_timeseries = new_timeseries.sort_by do |tsdata|
                       tsdata['timestamp']
                     end
    json_data["data"]["races"][0]["timeseries"] = new_timeseries
    json_data
  end

  def time_series_data
    @state_json_data["data"]["races"][0]["timeseries"]
  end

  def total_vote_count_drop
    return @total_vote_count_drop unless @total_vote_count_drop.nil?

    @total_vote_count_drop = 0
    time_series_data.each_with_index do |tsdata, index|
      next if index == 0

      current_votes = tsdata['votes']
      current_timestamp = tsdata['timestamp']
      last_votes = time_series_data[index - 1]['votes']
      last_timestamp = time_series_data[index - 1]['timestamp']
      if tsdata['votes'] < time_series_data[index - 1]['votes']
        @total_vote_count_drop += current_votes - last_votes
      end
    end
    @total_vote_count_drop
  end

  def vote_drop_total_for_candidate(candidate)
    candidate_key = candidate.downcase == 'trump' ? 'trumpd' : 'bidenj'
    sum = 0
    time_series_data.each_with_index do |tsdata, index|
      next if index == 0

      last_tsdata  = time_series_data[index - 1]
      last_total = last_tsdata['vote_shares'][candidate_key] * last_tsdata['votes']
      current_total =  tsdata['vote_shares'][candidate_key] * tsdata['votes']

      if last_total > current_total
        sum += current_total - last_total
      end
    end
    sum
  end

  def vote_drop_timeseries_data
    vote_drops = []
    time_series_data.each_with_index do |tsdata, index|
      next if index == 0

      current_votes = tsdata['votes']
      current_timestamp = tsdata['timestamp']
      last_votes = time_series_data[index - 1]['votes']
      last_timestamp = time_series_data[index - 1]['timestamp']
      if tsdata['votes'] < time_series_data[index - 1]['votes']
        vote_drops.push(tsdata)
      end
    end
    vote_drops
  end

  def print_report()
    puts "EVALUATING #{@state_name}"
    puts ""

    puts "Printing times where the lead switched"
    print_times_where_lead_switched

    puts "Printing times where the total vote count dropped"
    print_times_where_total_vote_count_dropped

    puts "Printing times where Trumps total dropped"
    print_times_where_candidate_total_dropped('Trump')

    puts "Printing times where Bidens total dropped"
    print_times_where_candidate_total_dropped('Biden')
  end

  def print_times_where_total_vote_count_dropped
    time_series_data.each_with_index do |tsdata, index|
      next if index == 0

      current_votes = tsdata['votes']
      current_timestamp = tsdata['timestamp']
      last_votes = time_series_data[index - 1]['votes']
      last_timestamp = time_series_data[index - 1]['timestamp']
      if tsdata['votes'] < time_series_data[index - 1]['votes']
        puts "total count dropped by #{current_votes - last_votes} between #{last_timestamp} and #{current_timestamp}"
      end
    end
    puts "TOTAL DROP WAS #{total_vote_count_drop}"
    puts "\n\n"
  end

  def print_times_where_lead_switched
    time_series_data.each_with_index do |tsdata, index|
      next if index == 0
      
      trump_key = 'trumpd'
      biden_key = 'bidenj'
      current_lead = tsdata['vote_shares'][trump_key] > tsdata['vote_shares'][biden_key] ? 'Trump' : 'Biden' 
      last_tsdata  = time_series_data[index - 1]
      last_lead = last_tsdata['vote_shares'][trump_key] > last_tsdata['vote_shares'][biden_key] ? 'Trump' : 'Biden'

      if last_lead != current_lead
        puts "Lead switched in #{current_lead}'s favor at #{tsdata['timestamp']}"
      end
    end
    puts "\n\n"
  end

  def print_times_where_candidate_total_dropped(candidate)
    total_drop = 0
    candidate_key = candidate.downcase == 'trump' ? 'trumpd' : 'bidenj' 

    time_series_data.each_with_index do |tsdata, index|
      next if index == 0
      last_tsdata  = time_series_data[index - 1]
      last_total = last_tsdata['vote_shares'][candidate_key] * last_tsdata['votes']
      current_total =  tsdata['vote_shares'][candidate_key] * tsdata['votes']

      if last_total > current_total
        puts "AT #{tsdata['timestamp']}, #{candidate}'s total dropped by #{current_total - last_total}"
        total_drop += current_total - last_total
      end
    end
    puts "TOTAL DROP FOR #{candidate.upcase} was #{total_drop}"
    puts "\n\n"
  end
end
