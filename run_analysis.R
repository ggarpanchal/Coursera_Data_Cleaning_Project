
file_name <- "raw_dataset.zip"

# Download and unzip the given dataset from url :
if (!file.exists(file_name)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file( URL, file_name, method= "curl" )
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file_name) 
}

# Load the datasets
train_data <- read.table("UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
test_data <- read.table("UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
all_data <- rbind(train_data, test_data)

train_activity <- read.table("UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE)
test_activity <- read.table("UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE)
all_activity <- rbind(train_activity, test_activity)

train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE)
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE)
all_subject <- rbind(train_subject, test_subject)

#
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F)
colnames(all_data) <- features[ , 2]
colnames(all_activity) <- "activity"
colnames(all_subject) <- "subject"

#
raw_data <- cbind(all_activity, all_subject, all_data)

# Extracts only the measurements on the mean and standard deviation for each measurement
extracted_data_index <- grep( "activity|subject|mean\\(\\)|std\\(\\)", colnames(raw_data) )
extracted_raw_data <- raw_data[, extracted_data_index]

#
activity_names <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F, col.names = c("ID", "Label"))
extracted_raw_data$activity <- factor(extracted_raw_data$activity, levels = activity_names[,1], labels = activity_names[,2])

#
names(extracted_raw_data)<-gsub("^t", "time", names(extracted_raw_data))
names(extracted_raw_data)<-gsub("^f", "frequency", names(extracted_raw_data))
names(extracted_raw_data)<-gsub("Acc", "Accelerometer", names(extracted_raw_data))
names(extracted_raw_data)<-gsub("Gyro", "Gyroscope", names(extracted_raw_data))
names(extracted_raw_data)<-gsub("Mag", "Magnitude", names(extracted_raw_data))
names(extracted_raw_data)<-gsub("BodyBody", "Body", names(extracted_raw_data))

#
library(dplyr)
tidy_data <- extracted_raw_data %>% group_by(subject, activity) %>% summarise_each(funs(mean))
write.table(tidy_data, "tidy_data.txt", row.names = FALSE, quote = FALSE)
