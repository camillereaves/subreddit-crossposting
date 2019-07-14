IMPORT STD;
IMPORT Reddit_ECL;


subCurrent := Reddit_ECL.Subreddits.Files.subreddit_clean_ds;  

/*PATTERN DEFINITION*/
	PATTERN Alpha := PATTERN('[A-Za-z]');

	PATTERN cross := ['x','cross']; 
	PATTERN sep := [' ','-'];
	PATTERN post := ['post','posted'];
	PATTERN xpost := cross OPT(sep) post;

	PATTERN direction := ['from','to'];

	PATTERN name := PATTERN('[a-z]')+;
	PATTERN rpref := 'r';
	PATTERN slash := ['\\', '/'];
	PATTERN subreddit := OPT(slash) rpref OPT(slash) OPT(sep) name;

	PATTERN statement := xpost OPT(sep) OPT(direction) OPT(sep) subreddit;

	RULE crossposted := (statement);

/* RECCORD LAYOUT : This is where the values of the parsed records is defined/given
to reference the subreddit_parsed_layouts, reference it via the Files module where there is an exported layout containing no definitions */
subreddit_parsed_layout := RECORD
	STRING8 subreddit_id := (STRING8)subCurrent.subreddit_ID;
	STRING9 post_ID := (STRING9)subCurrent.post_ID;	
	STRING273 title := (STRING)subCurrent.title;
	STRING42 cross_phrase := (STRING100)MATCHTEXT(statement);		
	STRING24 cross_subreddit_phrase := (STRING30)MATCHTEXT(statement/subreddit);
	STRING24 cross_subreddit_name := (STRING24)Std.Str.ToLowerCase(MATCHTEXT(statement/subreddit/name));
	STRING8 cross_subreddit_ID := '';			
END;

/*PARSING THE FILE*/
isCrossPosted := PARSE(subCurrent, title, crossposted, subreddit_parsed_layout, ALL, NOCASE);

OUTPUT(isCrossPosted,,Reddit_ECL.Subreddits.Files.subreddit_parsed_file_path, THOR, COMPRESSED, OVERWRITE);
