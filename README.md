# Getting_and_Cleaning_Data

The steps are described in this document:
1. read samples from raw data (including X,y,subject for test and train) , then merge the data by cbind

2. Extracts only the measurements on the mean and standard deviation for each measurement. In this section, the meanFreq is excluded. The extracted data set is named as all_mean_std

3. Uses descriptive activity names to name the activities in the data set. read activity_label.txt and label all_mean_std for each sample activity

4. Appropriately labels the data set with descriptive variable names. 
assign names for all_mean_std

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
split all_mean_data to each subject and label, then apply lapply for mean function to calculate the mean of each subject/activity_label. Finally, combine these data into new_data_set and write out new_data_set.txt