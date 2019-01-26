
file_name <- "raw_dataset.zip"

# Download and unzip the given dataset from url :
if (!file.exists(file_name)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file( URL, file_name, method= "curl" )
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file_name) 
}

#

activity_names <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F, col.names = c("ID", "Label"))
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F)

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

colnames(all_data) <- features[ , 2]
colnames(all_activity) <- "activity"
colnames(all_subject) <- "subject"

# cleaning dataframe & grep wanted variable (Mean & Standard Deviation)
features_filter <- grep( "*mean*|*std*", features[ , 2] )
features_data <- features[features_filter, 2]
features_data <- gsub("-mean", " mean", features_data)
features_data <- gsub("-std", " std", features_data)
features_data <- gsub("[-()]", "", features_data)

