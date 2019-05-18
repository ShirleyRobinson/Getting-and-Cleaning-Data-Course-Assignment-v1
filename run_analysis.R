## Downloading the data

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
unz(temp,"UCI HARdataset")
unlink(temp)

## Load dplyr package
library(dplyr)

   
## Assigning the datasets
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("Feature_no.","Feature_name"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "Activity_type"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$Feature_name)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$Feature_name)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## Merging the data sets
X_set<- rbind(x_train, x_test)
Y_labels<- rbind(y_train, y_test)
subject_set<- rbind(subject_train, subject_test)
merged_data<- cbind(subject_set, Y_labels, X_set)

## Extracts only the mean and std deviation for each measurement
TidyData<- select(merged_data, subject, code, contains("mean"), contains("std"))


## Uses descriptive activity names to name the activities in the data set
TidyData$code <- activities[TidyData$code, 2]

## Appropriately labels the data set with descriptive variable names
names(TidyData)[1] = "Subject"
names(TidyData)[2] = "Activity"
names(TidyData)<- gsub("Acc", "Accelerator", names(TidyData))
names(TidyData)<- gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<- gsub ("BodyBody", "Body", names(TidyData))
names(TidyData)<- gsub ("Mag", "Magnitude", names(TidyData))
names(TidyData)<- gsub ("^t", "Time", names(TidyData))
names(TidyData)<- gsub ("^f", "Frequency", names(TidyData))
names(TidyData)<- gsub ("tBody", "TimeBody", names(TidyData))
names(TidyData)<- gsub ("mean", "MeanValue", names(TidyData))

## From the extracted data, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
TidyData_gr<- group_by(TidyData, Subject, Activity)
TidyData2<- summarise_all(TidyData_gr, funs(mean)) 

write.table(TidyData2, "TidyData2.txt", row.name=FALSE)


