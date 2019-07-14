IMPORT STD;

/* CHECK 01_DATA_IMPORT_JOB.ECL TO MAKE SURE THAT YOUR ECL WATCH INFORMATION IS INPUT CORRECTLY TO GET THE FILES TO SPRAY TO YOUR LANDING ZONE */

EXPORT Subreddit_Files := MODULE
	EXPORT file_scope := '~cr';
        EXPORT project_scope := 'subreddits_directory';
        EXPORT in_files_scope := 'in';
        EXPORT out_files_scope := 'out';

//Location of raw file on the landing zone
        EXPORT subreddit_lz_file_path := '/var/lib/HPCCSystems/mydropzone/subreddits_directory_1000andabove.csv';

//Raw file layout and dataset after it is imported into Thor
        EXPORT subreddit_raw_file_path := file_scope + '::' + project_scope + '::' + in_files_scope + '::subreddits_directory.csv';			 
	EXPORT subreddit_raw_layout := RECORD
		STRING base10_ID;
		STRING base36_ID;
		STRING subreddit_name;
		STRING subscribers;
	END;
				
        EXPORT subreddit_raw_ds := DATASET(subreddit_raw_file_path, subreddit_raw_layout, CSV(HEADING(1)));

//EXPORT Data Profile report on the Raw File. Use the report output to understand your data and validate the assumptions you would have made.
        EXPORT subreddit_data_patterns_raw_file_path := file_scope + '::' + project_scope + '::' + out_files_scope +  '::subreddits_directory_raw_data_patterns.thor';

 //Cleaned file layout and dataset. The cleaned file is created after cleaning the raw file.
        EXPORT subreddit_clean_file_path := file_scope + '::' + project_scope + '::' + out_files_scope + '::subreddits_directory_clean.thor';
        EXPORT subreddit_clean_layout := RECORD
		UNSIGNED4 base10_ID;
		STRING8 base36_ID;
		STRING24 subreddit_name;
		UNSIGNED4 subscribers;
        END;

        EXPORT subreddit_clean_ds := DATASET(subreddit_clean_file_path, subreddit_clean_layout, THOR);    
 END;
