file_name <- "raw_dataset.zip"

# Download and unzip the given dataset from url :
if (!file.exists(file_name)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file( URL, file_name, method= "curl" )
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file_name) 
}

# Load the datasets and assign column names
train_data <- read.table("UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
test_data <- read.table("UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
all_data <- rbind(train_data, test_data)
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F)
colnames(all_data) <- features[ , 2]

train_activity <- read.table("UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE)
test_activity <- read.table("UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE)
all_activity <- rbind(train_activity, test_activity)
colnames(all_activity) <- "activity"

train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE)
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE)
all_subject <- rbind(train_subject, test_subject)
colnames(all_subject) <- "subject"

# Merge all dataset and create a complete raw dataset ( Step : 1 )
raw_data <- cbind(all_activity, all_subject, all_data)

# Extracts only the measurements on the mean and standard deviation for each measurement ( Step : 2 )
extracted_data_index <- grep( "activity|subject|mean\\(\\)|std\\(\\)", colnames(raw_data) )
extracted_raw_data <- raw_data[, extracted_data_index]

# Descriptive activity names to name the activities in the data set ( Step : 3 )
activity_names <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F, col.names = c("ID", "Label"))
extracted_raw_data$activity <- factor(extracted_raw_data$activity, levels = activity_names[,1], labels = activity_names[,2])

# Appropriately labels the data set with descriptive variable names ( Step : 4 )
names(extracted_raw_data)<-gsub("^t", "time", names(extracted_raw_data))
names(extracted_raw_data)<-gsub("^f", "frequency", names(extracted_raw_data))
names(extracted_raw_data)<-gsub("Acc", "Accelerometer", names(extracted_raw_data))
names(extracted_raw_data)<-gsub("Gyro", "Gyroscope", names(extracted_raw_data))
names(extracted_raw_data)<-gsub("Mag", "Magnitude", names(extracted_raw_data))
names(extracted_raw_data)<-gsub("BodyBody", "Body", names(extracted_raw_data))
tidy_data_full <- extracted_raw_data

# Independent tidy data set with the average of each variable for each activity and each subject ( Step : 5 )
library(dplyr)
tidy_data <- tidy_data_full %>% group_by(subject, activity) %>% summarise_each(funs(mean))
write.table(tidy_data, "tidy_data.txt", row.names = FALSE, quote = FALSE)
