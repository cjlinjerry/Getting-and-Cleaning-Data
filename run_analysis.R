setwd("C:/Users/jerrylin/Desktop/Data Science/Coursera 3 - Getting and Cleaning Data/Week 4")

# Import data
library(dplyr)
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
train <- read.table("./UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
test <- read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)

variables <- features[,2]

# Merge data and name the variables
total <- rbind(train, test)
names(total) <- variables
names(total)

# Extracts only the measurements on the mean and standard deviation for each measurement
# Use word boundry \b here to exclude meanFreq
mean_and_std <- grep("\\b[Mm]ean()\\b|\\b[Ss]td()\\b", names(total))
grep("\\b[Mm]ean()\\b|\\b[Ss]td()\\b", names(total), value = TRUE)
total_data <- total[, mean_and_std]

# Import label data and subject data
train_label <- read.csv("./UCI HAR Dataset/train/y_train.txt", header = FALSE, stringsAsFactors = FALSE)
test_label <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, stringsAsFactors = FALSE)
total_label <- rbind(train_label, test_label)
names(total_label) <- "activity"

train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
total_subject <- rbind(train_subject, test_subject)
names(total_subject) <- "subject"

# Bind label and subject with dataset
label_subject <- cbind(total_label, total_subject)
all_data <- cbind(label_subject, total_data)

# Uses descriptive activity names to name the activities in the data set
activity_label_name <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("activity", "activityname"))
all_data <- merge(all_data, activity_label_name, by.x = "activity", by.y = "activity")
all_data <- all_data[, c(69, 2:68)]

# Appropriately labels the data set with descriptive variable names
names(all_data)
# I didn't rename the variable names here because I don't think any change can 
# make them more descriptive, and I don't even understand those variable names
# If someone want to understand the variable names he/she can check the reference text file

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
data2 <- all_data
grouped_data <-  data2 %>%
        group_by(activityname, subject) %>% 
        summarise_each (funs(mean))
grouped_data
write.table(grouped_data, file = "./project.txt", row.names = FALSE)






