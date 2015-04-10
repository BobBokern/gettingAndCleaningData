#Step 1: Merges the training and the test sets to create one data set.
#Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
#Step 3: Uses descriptive activity names to name the activities in the data set
#Step 4: Appropriately labels the data set with descriptive variable names. 
#Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


if (!require("dplyr")) {
  install.packages("dplyr")
}

library('dplyr')

# #define URL where the data is stored
# fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# #create data directory if not exists
# if (!file.exists("data")) {
#   dir.create("data")
# }
# 
# #download zip file from the URL
# download.file(fileUrl, destfile = "./data/Dataset.zip", method = "internal")
# unzip("./data/Dataset.zip",exdir="./data")

#read all the data
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)
features <- read.table("./data/UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)[,2]

TrainingSet  <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
TrainLables  <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
TrainSubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

TestSet      <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
TestLabels   <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
TestSubject  <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Step 1: Merges the training and the test sets to create one data set.
DatasetAll  <- rbind(TrainingSet, TestSet)
LabelsAll   <- rbind(TrainLables, TestLabels)
SubjectAll  <- rbind(TrainSubject,TestSubject)

#Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.  
featuresMeanStd <- grep("mean\\()|-std\\()", features)
DatasetAll      <- DatasetAll[,featuresMeanStd]
colnames(DatasetAll) <- features[featuresMeanStd]

#Step 3: Uses descriptive activity names to name the activities in the data set
activity_descriptions <- activity_labels[,2]
LabelsToAdd <- activity_descriptions[LabelsAll[,1]]

#Step 4: Appropriately labels the data set with descriptive variable names. 
DatasetAllWithLabels <- cbind(SubjectAll,LabelsToAdd, DatasetAll)
names(DatasetAllWithLabels)[1] <- "Subject"
names(DatasetAllWithLabels)[2] <- "Activity"

#Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
uniqueActivities <- data.frame(sort(unique(DatasetAllWithLabels[,"Activity"])))
uniqueSubjects   <- data.frame(sort(unique(DatasetAllWithLabels[,"Subject"])))

numberOfActivities <- dim(uniqueActivities)[1]
numberOfSubjects   <- dim(uniqueSubjects)[1]

AverageDataSet <- matrix(NA,ncol=dim(DatasetAllWithLabels)[2],nrow=numberOfActivities * numberOfSubjects)

allCombinations <- NULL

for(index in 1:numberOfActivities){
  activity <- uniqueActivities[index,1]
  subjects <- uniqueSubjects[,1]
  name <- paste(activity,"-",subjects,sep="")
  
  allCombinations <- c(allCombinations,name)
}


colnames(AverageDataSet) <- colnames(DatasetAllWithLabels)


for(j in 3:length(colnames(AverageDataSet))){
  for(i in 1:length(allCombinations)){
    combination <- allCombinations[i]
    activitySubject <- strsplit(combination,split='-')[[1]]
    activity        <- activitySubject[1]
    subject         <- activitySubject[2]
    
    
    meanData <- DatasetAllWithLabels[,c(1,2,j)] %>% 
            filter(Subject == subject, Activity == activity) 
    
    mean <- mean(meanData[,3],na.rm=T)           
    
    AverageDataSet[i,1] <- subject
    AverageDataSet[i,2] <- activity
    AverageDataSet[i,j] <- mean               
  }
}

write.table(data.frame(AverageDataSet), "./AverageDataSet.txt",row.name=FALSE)

