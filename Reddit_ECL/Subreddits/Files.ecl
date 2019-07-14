IMPORT STD;

/* CHECK 01_DATA_IMPORT_JOB.ECL TO MAKE SURE THAT YOUR ECL WATCH INFORMATION IS INPUT CORRECTLY TO GET THE FILES TO SPRAY TO YOUR LANDING ZONE */

EXPORT Files := MODULE
				EXPORT file_scope := '~cr';
        EXPORT project_scope := 'subreddit_posts';
        EXPORT in_files_scope := 'in';
        EXPORT out_files_scope := 'out';
				EXPORT final_files_scope := 'results';

//Location of raw file on the landing zone -- to run a new file THE LANDING ZONE PATH IS THE ONLY THING YOU NEED TO CHANGE 
        EXPORT subreddit_lz_file_path := '/var/lib/HPCCSystems/mydropzone/catpictures.csv';

				EXPORT subreddit := subreddit_lz_file_path[33..(LENGTH(subreddit_lz_file_path) - 4)];


//Raw file layout and dataset after it is imported into Thor
        EXPORT subreddit_raw_file_path := file_scope + '::' + project_scope + '::' + in_files_scope + '::' + subreddit + '.csv';
											 
											 
				EXPORT subreddit_raw_layout := RECORD
					STRING created_utc;
					STRING score;
					STRING domain;
					STRING id;
					STRING title;
					STRING ups;
					STRING downs;
					STRING num_comments;
					STRING permalink;
					STRING selftext;
					STRING link_flair_text;
					STRING over_18;
					STRING thumbnail;
					STRING subreddit_id;
					STRING edited;
					STRING link_flair_css_class;
					STRING author_flair_css_class;
					STRING is_self;
					STRING name;
					STRING url;
					STRING distinguished;
				END;
				
				
        EXPORT subreddit_raw_ds := DATASET(subreddit_raw_file_path, subreddit_raw_layout, CSV(HEADING(1)));

//EXPORT Data Profile report on the Raw File. Use the report output to understand your data and validate the assumptions you would have made.
        EXPORT subreddit_data_patterns_raw_file_path := file_scope + '::' + project_scope + '::' + out_files_scope +  '::' + subreddit + '_raw_data_patterns.thor';
				
 //Cleaned file layout and dataset. The cleaned file is created after cleaning the raw file.
        EXPORT subreddit_clean_file_path := file_scope + '::' + project_scope + '::' + out_files_scope + '::' + subreddit + '_clean.thor';
        
        EXPORT subreddit_clean_layout := RECORD
						STRING8 subreddit_id;     /* base36 subreddit ID -- shifted up from below for ease of record reading*/
						STRING9 post_ID;				  /* FORMERLY 'NAME' -- base36 post ID -- shifted up from below for ease of record reading */
						STRING6 id;								/* post ID that is in the URL example: http://www.reddit.com/r/aww/comments/10ldxy/husky_party/ ID would be 10ldxy */
						STRING title;
	        END;

        EXPORT subreddit_clean_ds := DATASET(subreddit_clean_file_path, subreddit_clean_layout, THOR);   

// PARSED RECORD LAYOUT, PATH, AND DATASET		
				EXPORT subreddit_parsed_file_path := file_scope + '::' + project_scope + '::' + out_files_scope + '::' + subreddit + '_parsed_results.thor';
				EXPORT subreddit_parsed_layout := RECORD
						STRING8 subreddit_id;    						//base36 subreddit ID
						STRING9 post_ID;				  					//FORMERLY 'NAME'
						STRING title;												//full title text
						STRING100 cross_phrase;							//full pattern match found
						STRING30 cross_subreddit_phrase;		//whole phrase relating to crossposted subreddit
						STRING24 cross_subreddit_name;			//just the name of the crossposted subreddit (no 'r') -- CONVERTED TO LOWERCASE
						STRING8 cross_subreddit_ID;				  //base36_ID of cross-posted subreddit 
				END;
				
				EXPORT subreddit_parsed_ds := DATASET(subreddit_parsed_file_path, subreddit_parsed_layout, THOR);
				
 //ENRICHED RECORD LAYOUT, PATH, AND DATASET		-- here the cross-posted sub is confirmed to exist and the base36_ID of that sub is substituted for the name
				EXPORT subreddit_enriched_file_path := file_scope + '::' + project_scope + '::' + out_files_scope + '::' + subreddit + '_enriched_results.thor';
				EXPORT subreddit_enriched_layout := RECORD
						STRING8 subreddit_id;    						//base36 subreddit ID
						STRING9 post_ID;				  					//FORMERLY 'NAME'
						STRING title;										//full title text
						STRING100 cross_phrase;							//full pattern match found
						STRING30 cross_subreddit_phrase;		//whole phrase relating to crossposted subreddit
						STRING24 cross_subreddit_name;			//just the name of the crossposted subreddit (no 'r') 
						STRING8 cross_subreddit_ID;				  //base36_ID of cross-posted subreddit 
				END;
				
				EXPORT subreddit_enriched_ds := DATASET(subreddit_enriched_file_path, subreddit_enriched_layout, THOR);
				
				
//SUBREDDIT DIRECTORY RECORD LAYOUT AND DATASET	
				EXPORT subreddit_directory_layout := RECORD
					  UNSIGNED4 base10_id;
						STRING8 base36_id;
						STRING24 subreddit_name;
						UNSIGNED4 subscribers;
				END;
				
				EXPORT subreddit_directory := DATASET('~cr::subreddits_directory::out::subreddits_directory_clean.thor', subreddit_directory_layout, THOR);
				
//MASTER OUTPUT RECORD LAYOUT AND DATASET	
				//this file contains a list of the top 2500 subs and their base36_IDs (if found in directory)
				EXPORT MASTER_FILE_PATH := '~cr::subreddits_directory::out::MASTER_OUTPUT.thor';
			
				EXPORT subreddits_master_output_layout := RECORD
						STRING8  to_base36_id;					  
						STRING24 to_subreddit_name;
				END;			

				EXPORT MASTER_FILE := DATASET(MASTER_FILE_PATH, subreddits_master_output_layout, THOR);
				
				EXPORT CHILD_FILE_PATH := file_scope + '::' + project_scope + '::' + final_files_scope + '::' + subreddit + '_master_results.thor';
			
 END;
