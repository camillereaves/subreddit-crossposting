IMPORT STD;
IMPORT Reddit_ECL;
IMPORT Visualizer.Visualizer;
 
MASTER_OG := Reddit_ECL.Subreddits.Files.MASTER_FILE;
enrichedSet := Reddit_ECL.Subreddits.Files.subreddit_enriched_ds;	

crossIDSet := SET(enrichedSet, TRIM(cross_subreddit_ID));

resultsTable := TABLE(
	MASTER_OG, 
		{to_base36_id, 
		to_subreddit_name, 
		UNSIGNED8 currentSub := IF(MASTER_OG.to_base36_id != '',
			IF((MASTER_OG.to_base36_id IN crossIDSet), +1, +0), 
			+0)}, 
	to_base36_id);

sortedResults := SORT(resultsTable, -currentsub );

OUTPUT(sortedResults,,Reddit_ECL.Subreddits.Files.CHILD_FILE_PATH, THOR, COMPRESSED, OVERWRITE);

nonZeroResults := sortedResults(currentsub > 0);
 
OUTPUT(nonZeroResults, NAMED('count_by_crosspost'));
Visualizer.MultiD.Bar('count_by_crosspost_bar',, 'count_by_crosspost');

	
