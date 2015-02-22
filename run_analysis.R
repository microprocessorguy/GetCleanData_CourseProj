## -------------------------------------------
## Author: Krish Sundaresan
## Date: 20-FEB-2015
## -------------------------------------------
## Cleaning & Using the Human Activity Recognition Using Smartphones Data Set 
## dataset from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##
## Dependencies
##  - data.table package
##  - reshape2 package

library(data.table)
library(reshape2)

##################
# 1. Merge the training and the test sets to create one data set.
##################

# read the test set files
# data/measurements
TestSet_X <- read.table("./UCI HAR Dataset//test/X_test.txt", sep="", 
                        header=FALSE)
# activity
TestSet_y <- read.table("./UCI HAR Dataset//test/y_test.txt", sep="", 
                        header=FALSE)
# subjectID
TestSet_subj <- read.table("./UCI HAR Dataset//test/subject_test.txt", sep="", 
                        header=FALSE)

# read the training set files
# data/measurements
TrainSet_X <- read.table("./UCI HAR Dataset//train/X_train.txt", sep="", 
                        header=FALSE)
# activity
TrainSet_y <- read.table("./UCI HAR Dataset//train/y_train.txt", sep="", 
                        header=FALSE)
# subjectID
TrainSet_subj <- read.table("./UCI HAR Dataset//train/subject_train.txt", sep="", 
                           header=FALSE)

# read the variable names and activity labels
Features <- read.table("./UCI HAR Dataset//features.txt",sep="", 
                       header=FALSE)[,2]
ActivityLabels <- read.table("./UCI HAR Dataset//activity_labels.txt", 
                             header=FALSE)[,2]
# Add names to the columns in the data
names(TestSet_subj) <- c("SubjectID")
names(TrainSet_subj) <- c("SubjectID")
names(TestSet_X) <- Features
names(TrainSet_X) <- Features
TestSet_y[,2] <- ActivityLabels[TestSet_y[,1]]
names(TestSet_y) <- c("ActivityID","ActivityLabel")
TrainSet_y[,2] <- ActivityLabels[TrainSet_y[,1]]
names(TrainSet_y) <- c("ActivityID","ActivityLabel")

# create data tables and merge the two
TestData <- cbind(as.data.table(TestSet_subj),TestSet_y, TestSet_X)
TrainData <- cbind(as.data.table(TrainSet_subj),TrainSet_y,TrainSet_X)
MergedData <- rbind(TestData,TrainData)

##############
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive variable names. 
##############

# get the variables that are mean and std. dev
MeanStdevVars <- grepl("mean|std",Features)
MeanStdevTestData_X <- TestSet_X[,MeanStdevVars]
MeanStdevTrainData_X <- TrainSet_X[,MeanStdevVars]
MeanStdevTestData <- cbind(as.data.table(TestSet_subj), TestSet_y, 
                           MeanStdevTestData_X)
MeanStdevTrainData <- cbind(as.data.table(TrainSet_subj), TrainSet_y, 
                            MeanStdevTrainData_X)
# merged & labeled data table
MergedMeanStdevData <- rbind(MeanStdevTestData,MeanStdevTrainData)

###############
# 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
###############

# these are the identifier labels that we want to group for
IDLabels <- c("SubjectID","ActivityID","ActivityLabel")
# anything other than the IDs are the measure variables
VarLabels <- setdiff(colnames(MergedMeanStdevData), IDLabels)
# melt
MoltenData <- melt(MergedMeanStdevData, id=IDLabels, measure.vars=VarLabels)
# and recast with subject & activity as the variable and get its mean
DataOut <- dcast(MoltenData, SubjectID+ActivityID+ActivityLabel ~ variable, mean)

# write to file
write.table(DataOut, file = "./AvgPerSubjActivity_UCIHAR_Tidy.txt",row.name=F)

