IMPORT STD;
IMPORT Reddit_ECL;

Reddit_ECL.Subreddits.Subreddit_Directory.Subreddit_Files.subreddit_clean_layout clean(Reddit_ECL.Subreddits.Subreddit_Directory.Subreddit_Files.subreddit_raw_layout raw) := TRANSFORM
		SELF.base10_ID := (UNSIGNED4) raw.base10_ID;
		SELF.base36_ID := STD.Str.ToLowerCase((STRING8) raw.base36_ID);
		SELF.subreddit_name := STD.Str.ToLowerCase((STRING24) raw.subreddit_name);
		SELF.subscribers := (UNSIGNED4) raw.subscribers;
END;

cleanedStart := PROJECT(Reddit_ECL.Subreddits.Subreddit_Directory.Subreddit_Files.subreddit_raw_ds, clean(LEFT));  

sortedClean := SORT(cleanedStart, base10_ID, base36_ID);

dedupedClean := DEDUP(sortedClean, LEFT.base10_ID=RIGHT.base10_ID, LEFT.base36_ID=RIGHT.base36_ID);

cleaned := dedupedClean(subreddit_name != '');

OUTPUT(cleaned,,Reddit_ECL.Subreddits.Subreddit_Directory.Subreddit_Files.subreddit_clean_file_path, THOR, COMPRESSED, OVERWRITE);