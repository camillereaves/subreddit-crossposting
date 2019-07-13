IMPORT  Reddit_ECL;
IMPORT DataPatterns;

rawSubredditData := Reddit_ECL.Subreddits.Subreddit_Directory.Subreddit_Files.subreddit_raw_ds;
OUTPUT(rawSubredditData, NAMED('rawSubredditDataSample'));

rawSubredditProfileResults := DataPatterns.Profile(rawSubredditData, features := 'fill_rate,cardinality,best_ecl_types,lengths,patterns,modes');
OUTPUT(rawSubredditProfileResults,, Reddit_ECL.Subreddits.Subreddit_Directory.Subreddit_Files.subreddit_data_patterns_raw_file_path, OVERWRITE);