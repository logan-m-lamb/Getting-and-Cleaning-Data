## cookbook

# input data
run_analysis.R expects the input data to be exactly the contents of [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) archive extracted to `./UCI HAR Dataset`.

# output data
The output of run_analysis.R is tiddy.txt, an R table dump where the columns are the features in `./UCI HAR Dataset/features.txt` which contain `-std` or `-mean` in their name. Each row contains the mean for each feature across each subject and each activity.

# transformations
run_analysis.R does the following to transform the dataset into tiddy.txt

1. Get the features from test and train, then label them with the second column from features.txt.
2. Combine the test and train features into a single dataset, `features`.
3. Select only the features that involve a mean or std from the data.
4. Get the subjects from test and train, then combine them into `subjects`.
5. Combine `features` and `subjects`
6. Read the activities files in for test and train, then combine them into one table.
7. Read the activities label file in and perform an inner join on the activities to convert the test and training activity keys into activity labels
8. Combine the activity labels with `features` and `subjects`.  
9. Compute the mean of each feature for each subject, then do the same for each activity.
10. Output the resulting table to `tiddy.txt`
