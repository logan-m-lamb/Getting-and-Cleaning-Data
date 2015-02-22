analyze <- function(directory = "UCI HAR Dataset") {
  path <- getwd()
  setwd(directory)

  # get the features from test and train, then label them with the second column from features.txt
  feature_labels <- read.table("features.txt", header = FALSE)[,2]
  features_train <- read.table("train/X_train.txt", header = FALSE)
  features_test <- read.table("test/X_test.txt", header = FALSE)
  features <- rbind(features_train, features_test)
  # we apply the column names this way instead of in read.tables
  # because read.tables mangles the name, change hyphens and parenthesis to periods
  colnames(features) <- feature_labels 

  # only select features that involve a mean or std
  mean_std_labels <- grep("-mean|-std", colnames(features), value=TRUE)
  mean_std_features <- features[,mean_std_labels]

  # get the subjects
  subjects_train <- read.table("train/subject_train.txt", header = FALSE, col.names=c("subject"))
  subjects_test <- read.table("test/subject_test.txt", header = FALSE, col.names=c("subject"))
  subjects <- rbind(subjects_train, subjects_test)

  # combine the feature and subjects table
  data_raw <- cbind(mean_std_features, subjects)

  # get the activities which will correspond to each record in data_raw
  activity_train = read.table("train/y_train.txt", header = FALSE, col.names=c("activity_key"))
  activity_test = read.table("test/y_test.txt", header = FALSE, col.names=c("activity_key"))
  activity_keys = rbind(activity_train, activity_test)

  # do an inner join and column select to effectively convert the activity_keys to activity labels
  activity_labels <- read.table("activity_labels.txt", header = FALSE, col.names=c("activity_key", "activity"))
  activities <- merge(activity_keys, activity_labels)["activity"]
  
  # add activities to data_raw
  data <- cbind(data_raw, activities)

  # from the prompt: 
  # creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  # now compute the mean of each variable for each subject, then do the same for each activity
  mean_by_subject <- sapply(mean_std_labels, function(label) tapply(data[,label], data$subject, mean))
  mean_by_activity <- sapply(mean_std_labels, function(label) tapply(data[,label], data$activity, mean))
  
  data <- rbind(mean_by_subject, mean_by_activity)
  write.table(data, "tiddy.txt")

  setwd(path)
}