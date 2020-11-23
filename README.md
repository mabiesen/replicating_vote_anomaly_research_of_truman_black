# Replicating Results of Truman Black
This repository's purpose is to store detail on discrepancies noted by Truman Black, as well as attempting to replicate his results.

Truman Black's claim is that many votes were switched between candidates during the 2020 presidential election This is consistent with the weird drop in Trump totals we saw on the CNN feed.  Truman used Edison Research data provided by the New York times to conduct his study.  For more detail, please see [this_link](https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black/tree/main/truman_black)

**From my own review,  I can say that there are MANY anomalies in the Edison Research (via NewYorkTimes) data that Truman used.  IF the edison data is truthful, the anomalies absolutely deserve investigation**

This repository has been saved to archive.org to prevent disappearing

https://web.archive.org/web/20201123024901/https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black

## CONCLUSION / FINDINGS

See some of my results at [this link in this repository](https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black/tree/main/matts_fraudcatch_results)

It was difficult to read Truman Black's original script. I have not yet studied whether votes have switched between candidates, this is coming soon.  I have avoided looking into this thus far due to the potential for rounding error using the percentages provided in the data.

**However I can say definitively that EVERY state saw at least 1 occasion where votes dropped between time series data** (i.e., the first time series says 10 votes total for state and the following timeseries data shows 8 votes total for state).  I can also say definitively, **on average, SWING STATES SAW MORE OCCASIONS WHERE VOTE TOTALS DROPPED.**

Either the NYT/Edison data is flawed, or **a machine malfunction has occurred across all states**, or **some malicious actor(s) are committing fraud**

## REPLICATING MY RESULTS

I used Truman Blacks original data. You'll find Truman's original data in this repository, [HERE](https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black/tree/main/truman_black/truman_black_original_data)

You can also download the rar file that Truman saved, the link is found on [this page](https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black/tree/main/truman_black)

A few scripts have been created to assist with analysis
*  [State Edison Data](https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black/blob/main/matts_fraudcatch/state_edison_data.rb) - This class helps to obtain and report data for an individual state
*  [United States Edison Data](https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black/blob/main/matts_fraudcatch/united_states_edison_data.rb) - This class is used to allow one to iterate over all states quickly
*  [report_for_state.rb](https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black/blob/main/matts_fraudcatch/report_for_state.rb) - This script obtains edison data for a given state and prints out a report

The user will need to have the Ruby programming language, version does not matter

#### Using report_for_state.rb

If you are not familiary with ruby, this is the easiest script to use.

To use report_for_state.rb:
```
ruby report_for_state.rb
```

When prompted, provide a filepath to the state json of choice.  The script will run and print out relevant report data.

#### Using United States Edison Data

1. Get into an irb console
```
irb
```

2. Require the script into your console session
```
require './united_states_edison_data'
```

3. Instantiate united_states_edison_data with the path to your directory containing the state json data
```
us_edison_data = UnitedStatesEdisonData.new('/some/path/to/a/directory/')
```

Now, you should be able to access all of the methods provided by state edison data, these include:
* **state_edison_data(\<state_name\>)** - get the StateEdisonData for a given state.  Good for drilling into the particulars of a given state
* **states_with_vote_total_drop** - provides a list of states where vote totals dropped at least once
* **print_drop_totals_for_states** - iterates through all states and prints how much the total dropped for a given state
* **print_sorted_drop_totals_for_trump** - iterates through all states and prints out how much Trump's total votes dropped
* **print_sorted_drop_totals_for_biden** - iterates through all states and prints out how much Biden's total votes dropped
* **print_most_common_day_for_vote_drops_in_state** - iterates through all states and shows the most common day on which a states vote totals dropped
* **print_states_where_candiate_dropped_more(\<candidate\>)** - iterates and prints states where one candidate had a vote total drop greater than the other (i.e., if you supply 'trump' as the function argument, states where trump's total dropped more will be printed)
* **print_states_by_vote_drop_frequency** - iterates and prints the number of times we see the vote totals drop for a given state
  


## RESOURCES - DATA

Truman used NYT edison records.

These records showed to still be available to the public on 11/22/2020, but I don't trust that the data will always be available, thus I am saving links to data via archive.org for those states which are most pertinent.

As mentiond, You'll find Truman's original data in this repository, [HERE](https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black/tree/main/truman_black/truman_black_original_data)

PENNSYLVANIA DATA
https://web.archive.org/web/20201122180531/https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/race-page/pennsylvania/president.json

GEORGIA DATA
https://web.archive.org/web/20201122051408/https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/race-page/georgia/president.json

MICHIGAN DATA
https://web.archive.org/web/20201121170943/https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/race-page/michigan/president.json

OHIO DATA
https://web.archive.org/web/20201121181421/https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/race-page/ohio/president.json

WISCONSIN DATA
https://web.archive.org/web/20201121173813/https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/race-page/wisconsin/president.json

NEVADA DATA
https://web.archive.org/web/20201121172106/https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/race-page/nevada/president.json
