run_analysis<-function () {
  # 1 Merges the training and the test sets to create one data set.
  # train result, 561 variables
  X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
  y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
  subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
  # test result, 561 variables
  X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
  y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
  subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
  # test label, one of the activity_label
  #   y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
  # Merge data of X: measurement, y: activity label, subject: person id
  X<-rbind(X_train, X_test)
  y<-rbind(y_train, y_test)
  subject<-rbind(subject_train, subject_test)
  # combinae all data in one dataset: suject, label, measurements
  all_data<-cbind(subject,y,X)
  
  
  # 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
  X_feature_list<-read.table("./UCI HAR Dataset/features.txt")
  X_feature_name<-X_feature_list[,2]
  feature_name<-c("subject","label")
  for (i in 1:length(X_feature_name)) {
    feature_name<-c(feature_name,as.character(X_feature_name[i]))
  }
  # mean() index list
  feature_mean_all<-grep("mean()",feature_name)
  feature_meanFreq<-grep("meanFreq()",feature_name)
  feature_mean<-NULL
  for (i in 1:length(feature_mean_all)) {
    if (!(sum(feature_meanFreq==feature_mean_all[i]))) {
      feature_mean<-c(feature_mean, feature_mean_all[i])
    }
  }
  feature_mean_name<-feature_name[feature_mean]
  # std() index list
  feature_std<-grep("std()",feature_name)
  feature_std_name<-feature_name[feature_std]
  # mean/std data extract
  all_mean_std_index<-c(1,2,feature_mean, feature_std)
  all_mean_std<-all_data[,all_mean_std_index]
  
  # 3 Uses descriptive activity names to name the activities in the data set
  label_list<-read.table("./UCI HAR Dataset/activity_labels.txt")
  for (i in 1:length(all_mean_std[,2])) {
    num<-all_mean_std[i,2]
    all_mean_std[i,2]<-as.character(label_list[num,2])
  }
  
  # 4 Appropriately labels the data set with descriptive variable names. 
  names(all_mean_std)<-feature_name[all_mean_std_index]
  
  # 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  new_data_set<-NULL
  all_m_s_subject<-split(all_mean_std, all_mean_std$subject)
  for (i in 1:length(all_m_s_subject)) {
    temp_layer_1<-all_m_s_subject[[i]]
    all_m_s_subject_label<-split(temp_layer_1, temp_layer_1$label)
    for (j in 1:length(all_m_s_subject_label)) {
      temp_layer_2<-all_m_s_subject_label[[j]]
      subject_temp<-temp_layer_2[1,1]
      label_temp  <-temp_layer_2[1,2]
      mean_layer_2<-lapply(temp_layer_2[3:length(temp_layer_2)],mean)
      result_layer_2<-c(subject_temp, label_temp, mean_layer_2)
      new_data_set<-rbind(new_data_set,result_layer_2)
    }
  }
  new_data_frame<-data.frame(subject=as.integer(new_data_set[,1]), label=as.character(new_data_set[,2]))
  for (i in 3:(length(new_data_set[1,]))) {
    new_data_frame<-cbind(new_data_frame, as.numeric(new_data_set[,i]))
  }
  names(new_data_frame)<-names(all_mean_std)
  
  write.table(new_data_frame,file="new_data_set.txt",row.name=FALSE)
}



