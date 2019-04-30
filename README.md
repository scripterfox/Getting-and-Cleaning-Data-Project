# Getting-and-Cleaning-Data-Project
Repository for holding Course Project Docs
This Repository contains a single R script(run_analysis.R).

For best results, it should be loaded into a clean R environment.  The script uses the reshape2 and dplyr packages during execution and the order in which these packages are installed has been observed to cause issues so it is best to start with a clean R environment.

The file acts on data downloaded from this link:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
That data set should be downloaded and unzipped into R's working directory before executing the run_analysis.R script.  Alternately, R's working directory can be changed to the unzipped file location on the end user's machine prior to script execution.

The unzipped data is segmented into two groups; test data and training data.  During execution, the script loads both of these 
sets of data into their own data frames with appropriately named variables.  The two data frames are the combined to produce a 
single data frame containing all of the data.  This re-combined data frame is reconstructed via subsetting so that it includes
only the variables containing mean or standard deviation measurements from the device signals used in the study.  The activity
variable is then recoded into a factor type.  Finally, the data is melted, grouped and summarized into a tidy data set with the 
average of each variable for each activity and each subject.
