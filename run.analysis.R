##This R script called run_analysis.R does the following:
##1.Merges the training and the test sets to create one data set.
##2.Extracts only the measurements on the mean and standard deviation for each measurement.
##3.Uses descriptive activity names to name the activities in the data set
##4.Appropriately labels the data set with descriptive variable names.
##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Set your working directory where the zip file will be stored. 
##fileUrl is the object where the link is stored
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
##destfile is an object that stored the path where the zip file will be stored
destfile = "./Dataset.zip"
download.file(fileUrl,destfile = destfile,method = "curl")
##It will unzip the file UCI HAR Dataset in your working directory
unzip(destfile)

##Read activity labels which links the class labels with their activity name.
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
act_labels[,2] <- as.character(act_labels[,2]) 

##Read feature.txt: list of all features
features <- read.table("./UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

##Extract only the measurements on the mean and std deviation from feature file
ext_feature <- grep(".*mean.*|.*std.*",features[,2])
ext_feature.names <- features[ext_feature,2]

##Read and process test data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")[ext_feature]
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

##Read and process train data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")[ext_feature]
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

##Merge columns of test and train sets
test_df <- cbind(sub_test,y_test,x_test)
train_df <- cbind(sub_train,y_train,x_train)

##Merge row of test_df and train_df
df <- rbind(train_df,test_df)
##Change names of variables using ext_feature.names
colnames(df) <- c("subject","activity",ext_feature.names)

df ##shows all observations taken during test and train

##creates a second tidy data set with the average of each variable for each activity 
##and each subject.
df$activity <- factor(df$activity, levels = act_labels[,1],labels = act_labels[,2])
df$subject <- as.factor(df$subject)
df.melt <- melt(df,id=c("subject","activity"))
df.mean <- dcast(df.melt, subject + activity ~ variable, mean)

##Save data of df.mean in file "tidy.txt" which will be stored in your working directory
write.table(df.mean,"tidy.txt", row.names = FALSE,quote = FALSE)

tidy_df <- read.table("tidy.txt",header = TRUE)


