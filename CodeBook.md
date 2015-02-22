---
title: "Code Book for UCI HAR data set transformations"
author: "Krish Sundaresan"
date: "February 21, 2015"
output: html_document
---

## The Original Data Set

Original data source: UCI Human Activity Recognition Using Smartphones Data Set from 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The original data set contained a test set and training set with the following files/variables

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files were available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

## Tidy Data Set 

A tidy data set was generated from UCI-HAR data set described above. The following actions were taken:

- Merged the training and the test sets to create one data set.
- Extracted only the measurements on the mean and standard deviation for each measurement. 
- Used descriptive activity names to name the activities in the data set
- Appropriately labeled the data set with descriptive variable names. 

The data was cleaned up as follows:

- Read the original test and train data files using data.table. Code for reading test set shown below.
```{r}
# data/measurements file
TestSet_X <- read.table("./UCI HAR Dataset//test/X_test.txt", sep="", 
                        header=FALSE)
# activity file
TestSet_y <- read.table("./UCI HAR Dataset//test/y_test.txt", sep="", 
                        header=FALSE)
# subjectID file
TestSet_subj <- read.table("./UCI HAR Dataset//test/subject_test.txt", sep="", 
                        header=FALSE)
```

- Read the labels from "subject_*.txt" and "y_*.txt" files in test and train data set directories. These are the subject IDs and activity IDs, respectively.
- Read the mapping of activity ID to activity label from the "activity_labels.txt" file
- Read the variable names from the "features.txt" file
- Apply the names using the names() function
- Created data tables using cbind() and merged using rbind()
```{r}
TestData <- cbind(as.data.table(TestSet_subj),TestSet_y, TestSet_X)
TrainData <- cbind(as.data.table(TrainSet_subj),TrainSet_y,TrainSet_X)
MergedData <- rbind(TestData,TrainData)
```

## Transformations

The tidy data set was then tranformed into one containing the average of each variable for each subject and activity. The data transformations were done using melt() and dcast() as follows:

```{r}
# identifier labels that we want to group for
IDLabels <- c("SubjectID","ActivityID","ActivityLabel")
# anything other than the IDs are measure variables
VarLabels <- setdiff(colnames(MergedMeanStdevData), IDLabels)
# melt
MoltenData <- melt(MergedMeanStdevData, id=IDLabels, measure.vars=VarLabels)
# and recast with subject & activity as the variable and get its mean
DataOut <- dcast(MoltenData, SubjectID+ActivityID+ActivityLabel ~ variable, mean)
```

In the above code MergedMeanStdevData was the R data.table that contains the merged data set (i.e.) test + train sets from the original with descriptive variable names included. DataOut is the final data table with the averages computed for each combination of subject and activity. This data set was then written out to the output file "AvgPerSubjActivity_UCIHAR_Tidy.txt"

The final transformed data set in "AvgPerSubjActivity_UCIHAR_Tidy.txt" contains the following variables. As in the original data set, the measurement variables prefixed with a 't' denote time domain variables and those prefixed with an 'f' denote frequency domain variables. The units are the same as in the original.

- "SubjectID" 
- "ActivityID" 
- "ActivityLabel" 
- "tBodyAcc-mean()-X" 
- "tBodyAcc-mean()-Y" 
- "tBodyAcc-mean()-Z" 
- "tBodyAcc-std()-X" 
- "tBodyAcc-std()-Y" 
- "tBodyAcc-std()-Z" 
- "tGravityAcc-mean()-X" 
- "tGravityAcc-mean()-Y" 
- "tGravityAcc-mean()-Z" 
- "tGravityAcc-std()-X" 
- "tGravityAcc-std()-Y" 
- "tGravityAcc-std()-Z" 
- "tBodyAccJerk-mean()-X" 
- "tBodyAccJerk-mean()-Y"
- "tBodyAccJerk-mean()-Z"
- "tBodyAccJerk-std()-X"
- "tBodyAccJerk-std()-Y"
- "tBodyAccJerk-std()-Z"
- "tBodyGyro-mean()-X"
- "tBodyGyro-mean()-Y"
- "tBodyGyro-mean()-Z"
- "tBodyGyro-std()-X"
- "tBodyGyro-std()-Y"
- "tBodyGyro-std()-Z"
- "tBodyGyroJerk-mean()-X"
- "tBodyGyroJerk-mean()-Y"
- "tBodyGyroJerk-mean()-Z"
- "tBodyGyroJerk-std()-X"
- "tBodyGyroJerk-std()-Y"
- "tBodyGyroJerk-std()-Z"
- "tBodyAccMag-mean()"
- "tBodyAccMag-std()"
- "tGravityAccMag-mean()"
- "tGravityAccMag-std()"
- "tBodyAccJerkMag-mean()"
- "tBodyAccJerkMag-std()"
- "tBodyGyroMag-mean()"
- "tBodyGyroMag-std()"
- "tBodyGyroJerkMag-mean()"
- "tBodyGyroJerkMag-std()"
- "fBodyAcc-mean()-X"
- "fBodyAcc-mean()-Y"
- "fBodyAcc-mean()-Z"
- "fBodyAcc-std()-X"
- "fBodyAcc-std()-Y"
- "fBodyAcc-std()-Z"
- "fBodyAcc-meanFreq()-X"
- "fBodyAcc-meanFreq()-Y"
- "fBodyAcc-meanFreq()-Z"
- "fBodyAccJerk-mean()-X"
- "fBodyAccJerk-mean()-Y"
- "fBodyAccJerk-mean()-Z"
- "fBodyAccJerk-std()-X"
- "fBodyAccJerk-std()-Y"
- "fBodyAccJerk-std()-Z"
- "fBodyAccJerk-meanFreq()-X"
- "fBodyAccJerk-meanFreq()-Y"
- "fBodyAccJerk-meanFreq()-Z"
- "fBodyGyro-mean()-X"
- "fBodyGyro-mean()-Y"
- "fBodyGyro-mean()-Z"
- "fBodyGyro-std()-X"
- "fBodyGyro-std()-Y"
- "fBodyGyro-std()-Z"
- "fBodyGyro-meanFreq()-X"
- "fBodyGyro-meanFreq()-Y"
- "fBodyGyro-meanFreq()-Z"
- "fBodyAccMag-mean()"
- "fBodyAccMag-std()"
- "fBodyAccMag-meanFreq()"
- "fBodyBodyAccJerkMag-mean()"
- "fBodyBodyAccJerkMag-std()"
- "fBodyBodyAccJerkMag-meanFreq()"
- "fBodyBodyGyroMag-mean()"
- "fBodyBodyGyroMag-std()"
- "fBodyBodyGyroMag-meanFreq()"
- "fBodyBodyGyroJerkMag-mean()"
- "fBodyBodyGyroJerkMag-std()"
- "fBodyBodyGyroJerkMag-meanFreq()"


