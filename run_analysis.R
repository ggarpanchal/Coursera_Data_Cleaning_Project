
file_name <- "dataset.zip"

# Download and unzip the given dataset from url :
if (!file.exists(file_name)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file( URL, file_name, method= "curl" )
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file_name) 
}

features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F)
features_filter <- grep( "*mean*|*std*", features[ , 2] )
features_Data <- features[features_filter, 2]
