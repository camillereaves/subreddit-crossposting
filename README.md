# Online Communities: Mapping Subreddits by Content “Cross-Posting” 

## Abstract
The goal of this project is to map naturally-occurring inter-subreddit content sharing patterns on Reddit.com by analyzing how posts are shared (or “cross-posted”) between subreddits. When posts are shared in another subreddit, community habit is to give credit to the original poster with the phrase “cross-posted from /r/subredditname” or something following this pattern posted in the comment section of the post. Looking at the patterns of cross-posting, I want to determine the relationships between subreddits as determined by the content shared between them. I will then compare this to an existing relational map of subreddits on Reddit to determine if content sharing predominantly occurs along relational aligns or outside of them. 

## Introduction
This project aims to create the start of a map of post-flow across Reddit. I am looking to analyze how content flows between subreddits, by searching for content that has been cross-posted (as referenced in the title). 
 
This project required the use of multiple publicly available datasets [see: “Related Work & Resources” for full list], but the project has two major data components. The first is a list of all of Reddit subreddits as of April 2018. The second is a set of 2500 CSV files, one for each of the top 2500 subreddits and each containing the top 1000 posts for that subreddit. This project consists of ECL code to easily read in CSV files from the HPCC Landing Zone, spray them, validate their information, clean the data, and then parse, enrich, and analyze the data found [more detail on this process in “Experiments” next]. 
 
To understand the language of this project, as well as the structure of the site this project is analyzing, some background is required. Reddit.com is a massive social networking and forum site, with hundreds of thousands of subreddits and millions of users. Reddit is divided into “subreddits,” individual forums dedicated to specific topics and containing their own posts, information, moderators, and comment board. These are universally referred to as subreddits and individually referred to as their URL precursor and the name of the subreddit. For example: the forum dedicated to cute animals, found at reddit.com/r/Aww is referred to as either /r/aww or r/aww. Due to the high volume of users and subreddits, (as well as billions of posts), the /r/ subreddit identifier is used for subreddits and the /u/ user identifier is used for users (e.g. /u/camillereaves would be a link to a user). 
 
Users can “subscribe” to different subreddits, and their subscribed subreddits aggregate in their front page feed. Users can submit posts in the form of self-text (plain text forum post with title and optional body), image & video (a title and a link to an image/video), and links (title and URL). Users can “upvote” and “downvote” on posts, and the aggregate of this score decides the posts position on the subreddit feed and front page of users. The collective scores that a user receives on all posts is their “post karma”, and the collective scores that a user receives on all comments is their “comment karma”. Karma offers a way to rank users in popularity, as well as offering social clout on the website. 
 
Content found in one subreddit is often considered to be relevant to another subreddit by users. However, the social rules of Reddit discourage you from taking someone else’s content and reposting it somewhere else on the massive set of forums (creating a “repost” in the eyes of the community). As a way to share content without bringing out the mob that is often generated when a stolen repost is discovered, users have begun using the phrase “cross-posted”. This phrase can take a variety of structures, but always contains some form of cross-posted and a subreddit name and is almost always found at the end of a post title. Figure 1 shows a few real examples parsed from the dataset this project used. 

__*Figure 1:*__ *Truncated list of parsing results from the subreddit /r/DIY*

![Figure 1](https://i.imgur.com/GdLiRlH.png "Figure 1")

Here, you can see just a small sample of the ways that the cross-posting phrase can vary. This was one of the main challenges of the data analysis portion of this project.  

## Datasets & Bundles 
Before beginning my analysis, I had to obtain my datasets and get them ready to upload to the HPCC Landing Zone. Here is a complete list of my datasets and bundles used, as well as relevant information for each. It is important to note that datasets relied heavily on the fact that Reddit generates unique base36 IDs for every comment, user, post, and subreddit. Subreddit IDs are formatted as t5_[ID], and posts are formatting as t3_[ID]. These were used as the index values for all datasets.  
 
**2,500 .CSV files containing top 2.5 million posts, obtained from github.com/umbrae/reddit-top-2.5-million** 
+ This is a dataset of the top posts from Reddit, containing the top 1,000 all-time posts from the top 2,500 (SFW) subreddits, 2.5 million records in total. Top subreddits are established by subscriber count. + Data pulled August 15 – 20, August 2013. 
+ Each file is a CSV with the related subreddit as filename in format [subreddit_name].csv 
+ __Record Format:__ 
  + created_utc: *Unix Time Code*
  + score: *Aggregate score of the post* 
  + domain: *Domain of the post content* 
  + id: *Post ID from reddit URL, not the base36_ID of the post*
  + title: *Post title text*
  + ups: *Number of upvotes*
  + downs: *Number of downvotes*
  + num_comments: *Total number of comments on the post*
  + permalink: *Permanent URL for post on Reddit*
  + self_text: *Text in post, if any*
  + link_flair_text: *If link has flair added, this is the text the flair contains*
  + over_18: *Boolean flag for if the post is NSFW*
  + thumbnail: *URL for post thumbnal*
  + subreddit_id: *Reddit’s base36 ID for the post*
  + edited: *Boolean flag for if the post has been edited by the user*
  + link_flair_css_class: *Name of CSS class to be applied to flair if flair text exists on the link to the post*
  + author_flair_css_class: *Name of CSS class to be applied to flair if flair text exists on the author of the post*
  + is_self: *Boolean flag for if it is a self post, a text-only post that does not generate post karma for users*
  + name: *Base36 ID for post*
  + URL: *Link the post is linking to, if any*
  + Distinguished: *If poster holds special position on subreddit, e.g. moderator, the type appears here*
  
**subreddit_directory.CSV, obtained from files.pushshift.io/reddit/subreddits/** 
+ This is a dataset of the all subreddits on Reddit, data pulled April 2019. 
+ The original file had 1,048,576 in the original record format. For the sake of expediency and analysis, I took this subreddit, and narrowed it down to 31,659 records by: 
  + Removing all subreddits with <1000 subscribers 
  + Eliminating all subreddits missing base10/base36 IDs, subscriber numbers, or names 
  + Deduping subreddits based on base36_ID 
  + Eliminating the creation_epoch column 
+ __Original Record Format:__ 
  + base10_id: *Base10 ID generated for subreddit* 
  + reddit_base36_id: *Base36 ID generated for subreddit by Reddit* 
  + creation_epoch: *UTC creation epoch*  
  + subreddit_name: *String containing subreddit name*
  + number_of_subscribers: *Number of subscribers the subreddit has* 
+ __Updated Record Format:__ 
  + base10_id: *Base10 ID generated for subreddit* 
  + reddit_base36_id: *Base36 ID generated for subreddit by Reddit* 
  + subreddit_name: *String containing subreddit name* 
  + number_of_subscribers: *Number of subscribers the subreddit has* 
  
**Bundle: DataPatterns, obtained from github.com/HPCC-systems/DataPatterns** 
+ This is an ECL bundle that offers a set of basic profiling and research tools for datasets.  
+ This bundle was used to generate information like fill rate, cardinality, best ECL types, lengths, patterns, modes, etc. of datasets.  

**Bundle: Visualizer, obtained from github.com/HPCC-systems/Visualizer** 
+ This is an ECL bundle that offers a set of basic graphic generation tools that can be used to create visualizations from the results of queries written in ECL.  
+ This bundle was used to generate graphs for the project.  

## Experiments 
This project required a sequence of programs in two different areas. Both have a common thread, which is that before any analysis can be done, manual code for cleaning has to be written. When ECL Watch sprays a .CSV file, it doesn’t actually create record sets, split rows into columns, or do anything beyond outputting rows in the most basic single column format. Both areas of the project required this process to be manually coded for.  
 
Below, you can see the order that the programs were executed in, as well as their overarching use: 
1. **SUBREDDIT DIRECTORY:** Takes a data set containing subreddits on reddit as well as their base10 ID, base36 ID, subreddit name, and number of subscribers, and outputs a cleaned and organized sprayed file. 
    1. **[Subreddit_Files module](Reddit_ECL/Subreddits/Subreddit_Directory/Subreddit_Files.ecl):** Contains all record and dataset definitions for this area of the project. 
    2. **[Data Import Job](Reddit_ECL/Subreddits/Subreddit_Directory/01_Data_Import_Job.ecl):** Uses the STD.File.SprayVariable to spray the file on the landing zone to a logical file. 
    3. **[Data Import Validate Job](Reddit_ECL/Subreddits/Subreddit_Directory/02_Data_Import_Validate_Job.ecl):** Takes the new raw logical file and verifies it has been correctly sprayed by querying the logical file attributes. It then calls the subreddit_raw_ds dataset variable created in Subreddit_Files to output the raw logical file (still based on the CSV with rows grouped under single heading) to a dataset (separating by commas into columns and adding a record layout, also created in Subreddit_Files). 
    4. **[Data Patterns Job](Reddit_ECL/Subreddits/Subreddit_Directory/03_Data_Patterns_Job.ecl):** Using the Data Patterns bundle, fill rate, cardinality, best ECL types, lengths, patterns, modes are generated for the subreddit_raw_ds and output as subreddits_directory_raw_data_patterns.thor to the Logical Files.   
    5. **[Clean Job](Reddit_ECL/Subreddits/Subreddit_Directory/04_Clean_Job.ecl):** The final step for the subreddit directory code, this takes in the subreddit_raw_ds dataset and produces a subreddit_clean_ds by cleaning the data: the program makes sure all appropriate type casting has taken place, verifies that values exist, and sets subreddit_name to lower case (for ease of comparison purposes later on). It then sorts this dataset by base10 ID and then base36 ID, Dedups it based on these IDs, and then gives all rows where the subreddit_name isn’t blank to a new cleaned dataset. This is output to the Logical Files area on ECL Watch as the cleaned subreddit directory .thor file. 
2. **SUBREDDITS:** This takes in a CSV file for a subreddit, containing all information laid out above in “Datasets & Bundles > 2,500 .CSV files containing top 2.5 million posts > Record Format” and cleans it before performing and outputting analysis. 
    1. **[Files module](Reddit_ECL/Subreddits/Files.ecl):** Contains all record, path, and dataset definitions for this area of the project. To change the subreddit being analyzed, updating the Landing Zone file path (subreddit_lz_file_path) automatically creates all other paths, datasets, and definitions needed. This is the only thing in any of the code in this area that requires changing to run new subreddit files. 
    2. **[Data Import Job](Reddit_ECL/Subreddits/01_Data_Import_Job.ecl):** Uses STD.File.SprayVariable to spray the file from the landing zone to a logical file. 
    3. **[Data Import Validate Job](Reddit_ECL/Subreddits/02_Data_Import_Validate_Job.ecl):** Takes the new raw logical file and verifies it has been correctly sprayed by querying the logical file attributes. It then calls the subreddit_raw_ds dataset variable created in Files to output the raw logical file (still based on the CSV with rows grouped under single heading) to a dataset (separating by commas into columns and adding a record layout, also created in Files). 
    4. **[Data Patterns Job](Reddit_ECL/Subreddits/03_Data_Patterns_Job.ecl):** Using the Data Patterns bundle, fill rate, cardinality, best ECL types, lengths, patterns, modes are generated for the subreddit_raw_ds and output as [subredditname]\_directory_raw_data_patterns.thor to the Logical Files.   
    5. **[Clean Job](Reddit_ECL/Subreddits/04_Clean_Job.ecl):** The final step for the subreddit directory code, this takes in the subreddit_raw_ds dataset and produces a subreddit_clean_ds by cleaning the data. The new data has this format: 
        + STRING8 subreddit_id: *Base36 subreddit ID* 
        + STRING9 post_id: *Base36 post ID* 
        + STRING6 ID: *Post ID from URL (e.g. for “reddit.com/r/aww/comments/10ldxy/...” ID = 10ldxy)* 
        + STRING title: *Full title of the post as a string*  
    The dataset is then sorted by first subreddit_ID and then post_ID, deduped by post_ID and ID, checked for empty titles, and then output to the subreddit_clean_ds dataset defined in Files 
    6. **[Parse Data](Reddit_ECL/Subreddits/05_Parse_Data.ecl):** This is where the project switches from cleaning the data to actually analyzing it. This is file is the first of a three step process to parse, enrich, and then analyze and output the data. Here, I define my patterns, create a rule from the patterns, and then parse subreddit_clean_ds to generate subreddit_parsed_ds. This new data set has the format: 
        + STRING8 subreddit_id: *Base36 subreddit ID* 
        + STRING9 post_id: *Base36 post ID* 
        + STRING title: *Full title of the post as a string*
        + STRING42 cross_phrase: *Contains the full cross-post statement parsed.* 
        + STRING24 cross_subreddit_phrase: *Contains the full subreddit reference, including prefacing r* 
        + STRING24 cross_subreddit_name: *Contains just the subreddit_name of the subreddit referenced* 
        + STRING8 cross_subreddit_ID: *This is left blank for now, but it will contain the Base36 subreddit ID of the sub being posted from once the data is enriched* 
    7.  **[Enrich Parse Data](Reddit_ECL/Subreddits/06_Enrich_Parse_Data.ecl):** Using a JOIN, this compares the subreddit_parsed_ds to the subreddit_directory file (generated in Step 1) to give base36_ID values to cross_subreddit_ID by comparing the values of subreddit_name in the subreddit_directory to values of cross_sub_name in the subreddit_parsed_ds. It also makes sure that all values are properly type casted as the TRANSFORM function creates an enriched data set with the values from subreddit_parsed_ds and subreddit_directory. The created dataset is given to subreddit_enriched_ds from the Files module, and it has the same record structure as subreddit_parsed_ds but with cross_subreddit_ID given values.  
    8. **[Create Child Output](Reddit_ECL/Subreddits/07_Create_Child_Output.ecl):** This is the final part of the project. It takes in the MASTER_FILE logical file. This file contains a list of the top 2500 subs and their base36_IDs (if found in directory). It functions as a directory of just the subreddits that I have CSV files for.  Create_Child_Output creates a set of all cross_subreddit_IDs from subreddit_enriched_ds. It then uses a Table function to create a table where each row has 3 columns: the first is the subreddit base36 ID, the second the subreddit name, and the third is a value called “currentsub” which is 1 if the subreddit currently being analyzed has any posts crossposted from that sub, and 0 if it has not.  This final output is given as a table, sorted by currentsub in descending order (subs that have been crossposted to first), and as a bar graph, showing the subs posted to by subreddit ID. It is output to the [subreddit name]\_master_results.thor. 

## Results 
This code was run on /r/aww, /r/DIY, /r/AskComputerScience, /r/dataisbeautiful, and /r/catpictures. The following are some relevant results. Although (as outlined in the above) there were additional outputs generated along the steps, these are the ones that are the most useful from a data analysis view point. This data really shows how the type of subreddit affects content, and it begins to show how the subreddits relate to each other as they share content.  

### /r/aww 
#### Cross-Posted Posts 
![/r/aww cross-posted posts](https://i.imgur.com/AiK5QxM.png "/r/aww cross-posted posts")

#### Cross-Posted Subreddits 
![/r/aww cross-posted subreddits](https://i.imgur.com/2or1ZQO.png "/r/aww cross-posted subreddits")
 
### /r/DIY 
#### Cross-Posted Posts 
![/r/DIY cross-posted posts](https://i.imgur.com/6X4UOpH.png "/r/DIY cross-posted posts") 
 
This sub had significantly longer titles than many other subs, so title values are cropped. 
 
#### Cross-Posted Subreddits 
![/r/DIY cross-posted subreddits](https://i.imgur.com/AxQfcVP.png "/r/DIY cross-posted subreddits")

 
### /r/AskComputerScience 
#### Cross-Posted Posts 
![/r/AskComputerScience cross-posted posts](https://i.imgur.com/sYLgpkF.png "/r/AskComputerScience cross-posted posts")

#### Cross-Posted Subreddits 
![/r/AskComputerScience cross-posted subreddits](https://i.imgur.com/NBNxsbs.png "/r/AskComputerScience cross-posted subreddits")
  
### /r/DataIsBeautiful 
#### Cross-Posted Posts 
![/r/DataIsBeautiful cross-posted posts](https://i.imgur.com/b0KqviT.png "/r/DataIsBeautiful cross-posted posts")

 In addition to the above, there are another three pages of results like this. Out of 1000 posts, more than a tenth are cross posts (an extremely high rate, especially compared to the other subs looked at). I have omitted the following pages of post results in the interest of saving space.  
 
#### Cross-Posted Subreddits 
![/r/DataIsBeautiful cross-posted subreddits](https://i.imgur.com/3rvzdFw.png "/r/DataIsBeautiful cross-posted subreddits")
  

### /r/catpictures 
#### Cross-Posted Posts 
![/r/catpictures cross-posted posts](https://i.imgur.com/crUeq3D.png "/r/catpictures cross-posted posts")

#### Cross-Posted Subreddits 
![/r/catpictures cross-posted subreddits](https://i.imgur.com/eENXEzL.png "/r/catpictures cross-posted subreddits")
  

 
## Related Work & Resources 

### Related Works 
  > **Visualization of Related Subreddits, anvaka** (github) 
  >
  > The primary work that inspired this project was created by anvaka on github. They created a visualization of related subreddits, using the “Redditors who commented in this subreddit, also commented to...” suggestions that generate in subreddit side bars. 
  >
  > An interesting way to use this project is to generate cross-posting subs and then compare them to anvaka’s program to see how users move between subreddits based on both cross-posting and comments. 
  >
  > Anvaka’s program can be found at [anvaka.github.io/sayit/?query=](anvaka.github.io/sayit/?query=). 
  > 
  > Anvaka’s code can be found at [github.com/anvaka/sayit](github.com/anvaka/sayit). 
 
  > **Solutions ECL Training: Taxi Tutorial, HPCC Systems** (github) 
  > ***with reference to “An Unsung Art”, Guru Bandasha*** *(DataSeers.ai)* 
  >
  > The primary work that aided in the coding of this project was created by HPCC Systems on github. They created a training ECL program to analyze and predict New York City Traffic Data, using data pulled from CSV files.  
  > 
  > In particular, the data importing and cleaning portion of this project was built while referencing this code.  
  > 
  > HPCC System’s Taxi Tutorial code can be found at  [github.com/hpcc-systems/Solutions-ECL-Training/tree/master/Taxi_Tutorial](github.com/hpcc-systems/Solutions-ECL-Training/tree/master/Taxi_Tutorial). 
  > 
  > As a supplementary reference to this, Guru Bandasha’s accompanying blogpost on the DataSeers website was used to understand how the code fit together. This post can be found at [dataseers.ai/an-unsung-art/](dataseers.ai/an-unsung-art/). 
  
### Resources 
While ECL proves to be a highly efficient language for data mining, there are not many existing resources for it outside of HPCC System’s purview. As such, most of the resources used to help code this project are found on their website or their github. 
 
  > **ECL Language Reference, HPCC Systems** (HPCCSystems.com) 
  > 
  > The ECL Language Reference is the web version of their documentation PDF, with an interface that is a little easier to navigate. The full definitions of their standard library and the ECL language, as well as coding examples for each, can be found on area of their site. 
  > 
  > The top page of the ECL Language Reference can be found at [hpccsystems.com/training/documentation/ecl-language-reference/html](https://hpccsystems.com/training/documentation/ecl-language-reference/html). 
 
  > **HPCC Community Forum, HPCC Systems** (HPCCSystems.com) 
  > 
  > HPCC has a slew of administrators and experts that are constantly on their help forum, and most issues that couldn’t be resolved via the ECL Language Reference could be found here.  
  >
  > The main board of the HPCC Community Forum can be found at [hpccsystems.com/bb/index.php](hpccsystems.com/bb/index.php). 
 
  > **“Tips and Tricks for ECL – Part 2 – PARSE”, Richard Taylor** (HPCCSystems.com) 
  > 
  > A particularly useful resource I found was a blogpost covering in detail how PARSE is used in ECL, breaking down identifying and creating patterns, combining patterns, and creating rules from those patterns before using the rules generated to parse a dataset. 
  > 
  > This blog post can be found at [hpccsystems.com/blog/Tips_and_Tricks_for_ECL_Part2_PARSE](hpccsystems.com/blog/Tips_and_Tricks_for_ECL_Part2_PARSE). 

## Conclusion 
### Evaluating Results & What I Would Change 
My results were of a reasonable quality, and certainly provide interesting analysis, but limitations in ECL, programmer knowledge, and available resources lead to a few issues. I would like to address those here. 

First, my Cross-Posted Subreddits results. Rather than displaying a count of the number of times each sub was cross-posted to, as was my original goal, the lack of iteration in ECL and issues with the TABLE function lead to having to instead use a flag value to decide if yes, it had been cross-posted to in that sub, or no it had not.  

Secondly, my final results. My original plan was to have each subreddit’s [subredditname]\_master_results.thor file function as a child of a master class, which could then be denormalized so that each sub’s cross-posted subs could be seen in a single master file. However, to do this I required the use of the ECL Scheduler. My code was written so that when an event (a file arrive in the Landing Zone with type .CSV) was triggered, the scheduler could automatically run all subsequent files and generate the child class. On my current HPCC account, though, I could not get access to the ECL Scheduler, and the number of CSV files to go through was to great to do it manually. I explored using FUNCTIONMACRO, MACRO, and embedding both Python and JavaScript, but by the end of the project I was still unable to successfully find a method to do this.  

Finally, due to the lack of a master file, I was unable to create the visual map I had first set out to make. While the data I was able to gather was interesting, and will allow for good analysis of content flow between specific subreddits, I ultimately was unable to generate the bigger picture of how all subreddits come together during the scope of this project. 

### Going Forward 
In my opinion, there is certainly more work to be done with this project. I plan to add functionality to the code so that the number of times a subreddit is cross-posted to can be counted. In the near future, I look to further pursue automation of ECL code, so that all 2,500 subreddits can be analyzed. Once this is done, I plan to create a visualization map (similar to the map referenced earlier, created by Anvaka) of subreddit content sharing.  

Other worthwhile pursuits with this project would be to create a JSON parsing unit that could read directly from Reddit’s JSON code and give the results as cleaned data sets to the analysis and output code, so that more recent patterns could be established. An alternative pursuit with this project to get a more complete look at Reddit would be to increase the scope to more subreddits, more comments from those subreddits, and using a larger subreddit directory (one consisting of all subreddits, rather than those with > 1000 subscribers. )  

### Final Thoughts 
We’ve heard so much about how things change in the “age of the Internet,” but one of the, sometimes less obvious, changes is how our communities are shifting. With more and more of our interactions taking place online, the importance of online cultural communities is growing, and the amount of information available to analyze is ever expanding. Investigating how people and information flow across these communities with projects like this can help us discover more about human interaction: from the more simplistic questions, like how interests intersect, to the more complex questions, like how people intellectually rank the communities they’re in and how they interact with (and often seem to strive to pull together) the different groups they find themselves apart of. Data mining allows us to see invisible links that help human beings feel connected. 

In my opinion, this is just the beginning of this project.  
