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
end

#puts "Please provide the directory where state json is located"
#states_dir = gets.chomp


