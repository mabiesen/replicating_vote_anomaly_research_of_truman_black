# Replicating Results of Truman Black
This repository's purpose is to store detail on discrepancies noted by Truman Black, as well as attempting to replicate his results

This repository has been saved to archive.org to prevent disappearing

https://web.archive.org/web/20201123024901/https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black

## BACKGROUND - What is being claimed?

### Truman Black

Truman Black posted in this Blog:

https://thedonald.win/p/11Q8O2wesk/happening-calling-every-pede-to-/

https://web.archive.org/web/20201122021514/https://thedonald.win/p/11Q8O2wesk/happening-calling-every-pede-to-/

His work outlines many vote total irregularities across many states.  

Truman had seen the following gateway pundit article which sparked him to dig into data:

https://web.archive.org/web/20201115071545/https://www.thegatewaypundit.com/2020/11/breaking-huge-another-system-glitch-captured-live-cnn-election-night-20000-votes-swapped-trump-biden-video/

Truman found NYT data on elections that could be used for his analysis, he saved his specific data to an RAR file so as to prevent future changes to the dataset.

https://workupload.com/file/aTKhxPg2RTr

You'll find Truman's original data in this repository as well, [HERE](https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black/tree/main/truman_black/truman_black_original_data)

Truman created a python script to review the data, unfortunately it was a bit difficult to interpret.

https://workupload.com/start/DV4TvqtWEK8

You'll find Truman's original script in this repository as well, [HERE](https://github.com/mabiesen/replicating_vote_anomaly_research_of_truman_black/blob/main/truman_black/fraudcatch.py)

#### Truman's Claim

Truman's claim is that votes are being switched, across the country.  This is consistent with the oddity witnessed on the night of the election, where votes seemed to disappear from Trump in the CNN live vote count feed.

## CONCLUSION / FINDINGS

As mentioned, it was difficult to read Truman Black's original script.

I have not yet studied whether votes have switched between candidates.

**However I can say definitively that EVERY state saw at least 1 occasion where votes dropped between time series data** (i.e., the first time series says 10 votes total for state and the following timeseries data shows 8 votes total for state).  I can also say definitively, on average, SWING STATES SAW MORE OCCASIONS WHERE VOTE TOTALS DROPPED.

Either the NYT/Edison data is flawed, or **a machine malfunction has occurred across all states**, or **some malicious actor(s) are committing fraud**

## REPLICATING MY RESULTS

A few scripts have been created to assist with analysis
*  State Edison Data - This class helps to obtain and report data for an individual state
*  United States Edison Data - This class is used to allow one to iterate over all states quickly
*  report_for_state.rb - This script obtains edison data for a given state and prints out a report

#### USE

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
* state_edison_data(<state_name>) - get the StateEdisonData for a given state.  Good for drilling into the particulars of a given state
* states_with_vote_total_drop - provides a list of states where vote totals dropped at least once
* print_drop_totals_for_states - iterates through all states and prints how much the total dropped for a given state
* print_sorted_drop_totals_for_trump - iterates through all states and prints out how much Trump's total votes dropped
* print_sorted_drop_totals_for_biden - iterates through all states and prints out how much Biden's total votes dropped
* print_most_common_day_for_vote_drops_in_state - iterates through all states and shows the most common day on which a states vote totals dropped
* print_states_where_candiate_dropped_more(<candidate>) - iterates and prints states where one candidate had a vote total drop greater than the other (i.e., if you supply 'trump' as the function argument, states where trump's total dropped more will be printed)
* print_states_by_vote_drop_frequency - iterates and prints the number of times we see the vote totals drop for a given state
  


## RESOURCES - DATA

Truman used NYT edison records.

These records showed to still be available to the public on 11/22/2020, but I don't trust that the data will always be available, thus I am saving links to data via archive.org for those states which are most pertinent.

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
