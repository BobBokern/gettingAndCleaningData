##Getting and Cleaning Data CodeBook

This code book describes the variables, the data, and any transformations or work that I performed to clean up the data.

First of all, a full description of the data is available at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The specific dataset that was used for this assignment was downloaded via the following URL:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

When the run_analysis.R script will be executed the following actions will be performed to clean up the data:
*1) Read the files activity_labels.txt and features.txt 
*2) Read the files X_train.txt (which contains the training set), y_train.txt (contains the training labels) and subject_train.txt (contains the subject who performed the activity) from the data/train folder
*3) Read the files X_test.txt (which contains the test set), y_test.txt (contains the test labels) and subject_test.txt (contains the subject who performed the activity) from the data/train folder
*4) Bind the train and test data per type of file, resulting data frames are DatasetAll(10299x561), LabelsAll(10299x1) and SubjectAll(10299x1)
*5) Obtain all measurements from the features data which contain measurements based on the mean and standard deviation, by looking for features that contains "mean" or "std" in their names .
*6) Now take a subset of your DatasetAll, bind the Subject and Activity column to the data frame and select only the columns that corresponds to those measurements. Next, add those feature names as column names to the new data frame called DatasetAllWithLabels(10299x563).
*7) Now obtain from this DatasetAllWithLabels all the unique Activities(6) and all the unique Subjects(30) and create all unique Activity-Subject combinations (6*30=180)
*8) Create a matrix called AverageDataSet with the same columns as DatasetAllWithLabels and with a number of rows equal to all unique Activity-Subject combinations
*9) Loop over all the different combinations and variables, filter the rows which are related to this combination and variable and calculate the mean
*10) Add this mean to the corresponding Activity-Subject row and Variable column
*11) Write the resulting data frame AverageDataSet to the file AverageDataSet.txt in the current working directory

© Bob Bokern, 2015 All Rights reserved.