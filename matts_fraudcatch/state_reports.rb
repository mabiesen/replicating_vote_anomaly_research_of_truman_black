module StateReports
  PRINTING_SPACER = '------------------------------------------'

  def print_times_where_candidate_total_dropped(candidate)
    puts PRINTING_SPACER
    puts "PRINTING TIMES #{candidate}'s TOTAL DROPPED IN #{@state_name}"
    puts PRINTING_SPACER

    total_drop = 0
    candidate_key = candidate.downcase == 'trump' ? 'trumpd' : 'bidenj'

    comparative_time_series.each do |hsh|
      tsdata = hsh['current_data']
      last_tsdata  = hsh['previous_data']
      last_total = last_tsdata['vote_shares'][candidate_key] * last_tsdata['votes']
      current_total =  tsdata['vote_shares'][candidate_key] * tsdata['votes']

      lead_no_switch_statement = "The lead did not switch"
      lead_switch_statement = "The lead switched in #{hsh['lead_switched']}'s favor"
      if last_total > current_total
        puts "AT #{tsdata['timestamp']}, #{candidate}'s total dropped by #{current_total - last_total}\n"\
             "Total drop for timeframe was #{hsh['amount_dropped']}\n"\
             "#{hsh['lead_switched'].nil? ? lead_no_switch_statement : lead_switch_statement}\n\n"
        total_drop += current_total - last_total
      end
    end
    puts "TOTAL DROP FOR #{candidate.upcase} was #{total_drop}"
    puts PRINTING_SPACER
    puts "\n\n"
  end

  def print_times_where_total_vote_count_dropped
    puts PRINTING_SPACER
    puts "PRINTING TIMES TOTAL COUNT DROPPED IN #{@state_name}"
    puts PRINTING_SPACER
    data_array = comparative_time_series
    times_total_vote_count_dropped.each do |hsh|
      lead_no_switch_statement = "The lead did not switch"
      lead_switch_statement = "The lead switched in #{hsh['lead_switched']}'s favor"
      puts "total count dropped by #{hsh['amount_dropped']}\n"\
           "between #{hsh['previous_data']['timestamp']} "\
           "and #{hsh['current_data']['timestamp']}\n"\
           "#{hsh['lead_switched'].nil? ? lead_no_switch_statement : lead_switch_statement}\n\n"

    end
    puts "TOTAL DROP FOR STATE WAS #{data_array.sum{|hsh| hsh['amount_dropped']}}"
    puts PRINTING_SPACER
    puts "\n\n"
  end

  def print_times_where_lead_switched
    puts PRINTING_SPACER
    puts "PRINTING TIMES LEAD SWITCHED IN #{@state_name}"
    puts PRINTING_SPACER
    data_array = comparative_time_series
    times_lead_switched.each do |hsh|
      total_counts_dropped_statement = hsh['amount_dropped'].nil? ? 'did not drop' : "dropped by #{hsh['amount_dropped']}"
      lead_switch_statement = "The lead switched in #{hsh['lead_switched']}'s favor"
      puts "#{lead_switch_statement} at #{hsh['current_data']['timestamp']}\n"\
           "Total vote counts #{total_counts_dropped_statement}\n\n"

    end
    puts "TOTAL DROP FOR STATE WAS #{data_array.sum{|hsh| hsh['amount_dropped']}}"
    puts PRINTING_SPACER
    puts "\n\n"
  end

end
