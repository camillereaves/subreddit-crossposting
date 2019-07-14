IMPORT STD;
IMPORT Reddit_ECL;

//if using a machine with a different IP, change the first value to your ECL Watch IP, and the final link to your ECL Watch IP
STD.File.SprayVariable('192.168.56.102',
	Reddit_ECL.Subreddits.Files.subreddit_lz_file_path,
	,,,,
	'mythor',
	Reddit_ECL.Subreddits.Files.subreddit_raw_file_path,
	-1,
	'http://192.168.56.102:8010/FileSpray',,TRUE);
