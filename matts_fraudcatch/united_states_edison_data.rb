require_relative 'state_edison_data'
require 'tmpdir'
require 'fileutils'
require 'open-uri'

class UnitedStatesEdisonData
  attr_reader :all_states_edison_data

  # leaving nil, the script will fetch fresh data
  def initialize(directory=nil)
    @all_states_edison_data = []
    if directory.nil?
      state_names_list.each do |state_name|
        Dir.mktmpdir do |d|
          path = "#{d}/#{state_name}.json"
          data_stream = fetch_fresh_data(state_name)
          File.open(path, 'w'){|f| f.write(File.read(data_stream.path))}
          @all_states_edison_data.push(StateEdisonData.new(path))  
        end
      end
    else
      Dir["#{directory}*.json"].each do |json_file|
        @all_states_edison_data.push(StateEdisonData.new(json_file))
      end 
    end
  end

  def fetch_fresh_data(state_name)
    url = "https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/race-page/STATEPLACEHOLDER/president.json"
    url = url.gsub('STATEPLACEHOLDER', state_name)
    open(url)
  end

  def state_edison_data(state_name)
    @all_states_edison_data.find {|state_data| state_data.state_name.downcase == state_name.downcase}
  end

  def states_with_vote_total_drop
    states = @all_states_edison_data.select {|state_data| state_data.total_vote_count_drop  < 0}
    states.map{|state| state.state_name}
  end

  def print_drop_totals_for_states
    @all_states_edison_data.each do |state|
      state.print_times_where_total_vote_count_dropped
    end
  end

  def print_sorted_state_drop_totals_for_trump
    sorted = @all_states_edison_data.sort_by {|state| state.trump_total_drop}
    sorted.each do |state|
      puts "State: #{state.state_name}, Trump total drop: #{state.trump_total_drop}"
    end
  end

  def print_sorted_state_drop_totals_for_biden
    sorted = @all_states_edison_data.sort_by {|state| state.biden_total_drop}
    sorted.each do |state|
      puts "State: #{state.state_name}, Biden total drop: #{state.biden_total_drop}"
    end
  end

  def print_most_common_day_for_vote_drops_in_state
    @all_states_edison_data.each do |state|
      date_count = Hash.new(0)
      dates = state.times_total_vote_count_dropped.map{|x| x['current_data']['timestamp'].to_date}
      dates.each {|date| date_count[date] += 1}
      most_common_date = date_count.sort_by { |date,number| number}.last[0]
      puts "State #{state.state_name} most commonly dropped votes on #{most_common_date}"
    end
  end

  def print_states_where_candiate_dropped_more(candidate)
    if candidate.downcase == 'biden'
      @all_states_edison_data.select{|state| state.biden_total_drop < state.trump_total_drop}.each{|state| puts state.state_name}
    else
      @all_states_edison_data.select{|state| state.biden_total_drop > state.trump_total_drop}.each{|state| puts state.state_name}
    end
  end

  def print_states_by_vote_drop_frequency
    sorted = @all_states_edison_data.sort_by {|state| state.times_total_vote_count_dropped.count}
    sorted.each do |state|
      puts "State: #{state.state_name} Dropped Votes #{state.times_total_vote_count_dropped.count} times"
    end
  end

  def print_winner_for_states
    @all_states_edison_data.each{|state| puts "#{state.state_name}: #{state.winner}"}
  end

  def print_winner_and_if_winner_dropped_more
    @all_states_edison_data.each do |state| 
      did_winner_drop_more = state.winner == 'biden' ? state.biden_total_drop < state.trump_total_drop : state.biden_total_drop > state.trump_total_drop
      puts "#{state.state_name}: #{state.winner}: winner dropped more? #{did_winner_drop_more}"
    end
  end

  def print_states_where_trump_won_and_dropped_more
    puts "Printing States Where Trump Won And Dropped More Votes"
    @all_states_edison_data.each do |state|
      next unless state.winner == 'trump'

      did_winner_drop_more = state.biden_total_drop > state.trump_total_drop
      if did_winner_drop_more
        puts state.state_name
      end
    end
  end

  def print_states_where_biden_won_and_dropped_more
    puts "Printing States Where Biden Won And Dropped More Votes"
    @all_states_edison_data.each do |state|
      next unless state.winner == 'biden'

      did_winner_drop_more = state.biden_total_drop < state.trump_total_drop
      if did_winner_drop_more
        puts state.state_name
      end
    end
  end
end

def state_names_list
  %w[alabama
  alaska
  arizona
  arkansas
  california
  colorado
  connecticut
  delaware
  florida
  georgia
  hawaii
  idaho
  illinois
  indiana
  iowa
  kansas
  kentucky
  louisiana
  maine
  maryland
  massachusetts
  michigan
  minnesota
  mississippi
  missouri
  montana
  nebraska
  nevada
  new-hampshire
  new-jersey
  new-mexico
  new-york
  north-carolina
  north-dakota
  ohio
  oklahoma
  oregon
  pennsylvania
  rhode-island
  south-carolina
  south-dakota
  tennessee
  texas
  utah
  vermont
  virginia
  washington
  west-virginia
  wisconsin
  wyoming]
end
