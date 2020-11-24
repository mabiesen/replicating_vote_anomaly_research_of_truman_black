require_relative 'state_edison_data'

puts "Please supply the filepath for the state you wish to examine"
state_filepath = gets.chomp

# instantiate edidson state data class
sed = StateEdisonData.new(state_filepath)
sed.print_report
