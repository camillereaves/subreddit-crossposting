IMPORT STD;
IMPORT Reddit_ECL;

file := Reddit_ECL.Subreddits.Subreddit_Directory.Subreddit_Files.subreddit_raw_file_path;

OUTPUT(STD.File.GetLogicalFileAttribute(file,'recordSize'),NAMED('Record_Size'));
OUTPUT(STD.File.GetLogicalFileAttribute(file,'recordCount'),NAMED('Record_Count'));
OUTPUT(STD.File.GetLogicalFileAttribute(file,'size'),NAMED('File_Size'));
OUTPUT(STD.File.GetLogicalFileAttribute(file,'clusterName'),NAMED('Cluster_Name'));
OUTPUT(STD.File.GetLogicalFileAttribute(file,'directory'),NAMED('Directory'));
OUTPUT(STD.File.GetLogicalFileAttribute(file,'numparts'),NAMED('Data_Parts'));


OUTPUT(Reddit_ECL.Subreddits.Subreddit_Directory.Subreddit_Files.subreddit_raw_ds,,NAMED('Raw_Subreddit_Data'));