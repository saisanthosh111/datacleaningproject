#loading the required packages

library(dplyr)

#Downloading the dataset and unzipping

filen<-"coursera.zip"
if (!file.exists(filen)){
  file_url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url=file_url,destfile="'/filen",method = "curl")
}
if (!file.exists("UCI HAR Dataset")){
  unzip(filen)
}

# assigning all dataframes
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#merging train and test

X<-rbind(x_test,x_train)
Y<-rbind(y_test,y_train)
subject<-rbind(subject_test,subject_train)
mdata<-cbind(X,Y,subject)

#mean and sd

TidyData<-mdata %>% select(subject,code,contains("mean"),contains("std"))

#descriptive activity

TidyData$code <- activities[TidyData$code, 2]

#making labels with descriptive variable names

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

#creating the average by their acitivity and subject

FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)


