IMPORT STD;
IMPORT Reddit_ECL;

Reddit_ECL.Subreddits.Files.subreddit_enriched_layout enrich(Reddit_ECL.Subreddits.Files.subreddit_directory_layout dir, Reddit_ECL.Subreddits.Files.subreddit_parsed_layout parsed) := TRANSFORM
	SELF.subreddit_id := (STRING8)parsed.subreddit_id;    										//base36 subreddit ID
	SELF.post_ID := (STRING9)parsed.post_ID;				  												//FORMERLY 'NAME'
	SELF.title := (STRING)parsed.title;																				//full title text
	SELF.cross_phrase := (STRING42)parsed.cross_phrase;												//full pattern match found
	SELF.cross_subreddit_phrase := (STRING30)parsed.cross_subreddit_phrase;		//whole phrase relating to crossposted subreddit
	SELF.cross_subreddit_name := (STRING24)parsed.cross_subreddit_name;				//just the name of the crossposted subreddit (no 'r') 		
	SELF.cross_subreddit_ID := (STRING8)dir.base36_ID;												//base36_ID of cross-posted subreddit
END;

enriched := JOIN(Reddit_ECL.Subreddits.Files.subreddit_directory, Reddit_ECL.Subreddits.Files.subreddit_parsed_ds, LEFT.subreddit_name = RIGHT.cross_subreddit_name, enrich(LEFT, RIGHT), RIGHT OUTER);

OUTPUT(enriched,,Reddit_ECL.Subreddits.Files.subreddit_enriched_file_path, THOR, COMPRESSED, OVERWRITE);
