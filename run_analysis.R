##STEP 1
##Load/Read the files: X_train.txt, y_train.txt, subject_train.txt, x_test.txt, y_test.txt, subject_test.txt, features.txt, activity_labels.txt
x_train <- read.table("./project/X_train.txt")
y_train <- read.table("./project/y_train.txt")
subject_train <- read.table("./project/subject_train.txt")
x_test <- read.table("./project/x_test.txt")
y_test <- read.table("./project/y_test.txt")
subject_test <- read.table("./project/subject_test.txt")
features <- read.table("./project/features.txt")
activity_labels <- read.table("./project/activity_labels.txt")

##Rename columns in each dataset and assign 2nd column of features.txt to x_train and x_test as column names.
##Rename column names for activity labels
colnames(activity_labels) <- c('activityID','activity')
##Rename columns for training data
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityID"
colnames(subject_train) <- "subjectID"
##Rename columns for test data
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

##Merge datasets for training data and test data.
##Training data
trainData <- cbind(y_train, x_train, subject_train)
##Test data
testData <- cbind(y_test, x_test, subject_test)
##Merge both datasets
allData <- rbind(trainData, testData)

##STEP 2
##Create colNames in order to select the data for mean and standard deviation 
colNames <- colnames(allData)

##Use grepl to sort out columns that include subjectID, activityID, -mean()- and -std()-..
means_std <- (grepl("subjectID",colNames) | grepl("activityID",colNames) | grepl("mean..",colNames) | grepl("std..",colNames))

##To get/show the needed columns as specified above, we must use the ==TRUE operator
allData <- allData[means_std==TRUE]

##STEP 3
##Use descriptive names for the activties, which is done by merging the activity_labels dataset with our allData set.
allDataAct <- merge(allData, activity_labels, by="activityID", all.x=TRUE)

##STEP 4 Labeling of variables has been done throughout the process.
##STEP 5
##Create a new dataset with average of each variable for each activity and each subject using aggregate.
meanData <- aggregate(. ~subjectID + activityID, allDataAct, mean)
##Order the new data set according to subjectID and then by activityID
meanData <- meanData[order(meanData$subjectID, meanData$activityID),]
##Write table
write.table(meanData, "./project/meanData.txt", row.name=FALSE)
