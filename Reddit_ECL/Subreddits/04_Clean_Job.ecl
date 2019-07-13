IMPORT STD;
IMPORT Reddit_ECL;

Reddit_ECL.Subreddits.Files.subreddit_clean_layout clean(Reddit_ECL.Subreddits.Files.subreddit_raw_layout raw) := TRANSFORM
		SELF.subreddit_id := (STRING8) raw.subreddit_id;
		SELF.post_ID := (STRING9) raw.name;
		SELF.id := (STRING6) raw.id;
		SELF.title := (STRING) raw.title;
END;

cleanedStart := PROJECT(Reddit_ECL.Subreddits.Files.subreddit_raw_ds, clean(LEFT));  

sortedClean := SORT(cleanedStart, subreddit_ID, post_ID);

dedupedClean := DEDUP(sortedClean, LEFT.post_ID=RIGHT.post_ID, LEFT.id=RIGHT.id);

cleaned := dedupedClean(title != '');

OUTPUT(cleaned,,Reddit_ECL.Subreddits.Files.subreddit_clean_file_path, THOR, COMPRESSED, OVERWRITE);
