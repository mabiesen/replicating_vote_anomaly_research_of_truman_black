require_relative 'state_edison_data'

class UnitedStatesEdisonData
  attr_reader :all_states_edison_data

  def initialize(directory)
    @all_states_edison_data = []

    Dir["#{directory}*.json"].each do |json_file|
      @all_states_edison_data.push(StateEdisonData.new(json_file))
    end 
  end

  def state_edison_data(state_name)
    @all_states_edison_data.find {|state_data| state_data.state_name == state_name}
  end

  def states_with_vote_total_drop
    states = @all_states_edison_data.select {|state_data| state_data.total_vote_count_drop  < 0}
    states.map{|state| state.state_name}
  end

  def print_drop_totals_for_states
    @all_states_edison_data.each do |state|
      puts "State: #{state.state_name}, TOTAL DROP: #{state.total_vote_count_drop}, Biden dropped more? #{state.biden_drop_more_than_trump?}"
    end
  end

  def print_sorted_drop_totals_for_trump
    sorted = @all_states_edison_data.sort_by {|state| state.trump_total_drop}
    sorted.each do |state|
      puts "State: #{state.state_name}, Trump total drop: #{state.trump_total_drop}"
    end
  end

  def print_sorted_drop_totals_for_biden
    sorted = @all_states_edison_data.sort_by {|state| state.biden_total_drop}
    sorted.each do |state|
      puts "State: #{state.state_name}, Biden total drop: #{state.biden_total_drop}"
    end
  end

  def print_most_common_day_for_vote_drops_in_state
    @all_states_edison_data.each do |state|
      date_count = Hash.new(0)
      tsdata = state.vote_drop_timeseries_data
      dates = tsdata.map{|data| data['timestamp'].to_date}
      dates.each {|date| date_count[date] += 1}
      most_common_date = date_count.sort_by { |date,number| number}.last[0]
      puts "State #{state.state_name} most commonly dropped votes on #{most_common_date}"
    end
  end

  def print_states_where_candiate_dropped_more(candidate)
    if candidate.downcase == 'biden'
      @all_states_edison_data.select{|state| state.biden_drop_more_than_trump?}.each{|state| puts state.state_name}
    else
      @all_states_edison_data.select{|state| !state.biden_drop_more_than_trump?}.each{|state| puts state.state_name}
    end
  end
end

