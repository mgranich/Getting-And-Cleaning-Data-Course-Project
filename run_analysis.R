library(plyr)

#
# 1. Read in the test and training set files into table variables and merge the data.
#

x_data_train <- read.table("train/X_train.txt")
y_data_train <- read.table("train/y_train.txt")
subject_data_train <- read.table("train/subject_train.txt")

x_data_test <- read.table("test/X_test.txt")
y_data_test <- read.table("test/y_test.txt")
subject_data_test <- read.table("test/subject_test.txt")

# bind train and test for your merged data sets
x_bound_data <- rbind(x_data_train, x_data_test)
y_bound_data <- rbind(y_data_train, y_data_test)
subject_bound_data <- rbind(subject_data_train, subject_data_test)

# 
# 2. Read in the features and rename the column names
#

features <- read.table("features.txt")

# grep out features for standard dev and mean and pull out the data
stat_features <- grep("-(std|mean)\\(\\)", features[, 2])
x_bound_data <- x_bound_data[, stat_features]

# rename columns
names(x_bound_data) <- features[stat_features, 2]

# 
# 3. Apply the activities in the data set
#


# Read in Activity labels
activity_labels <- read.table("activity_labels.txt")

# Apply the activity names and column name
y_bound_data[, 1] <- activity_labels[y_bound_data[, 1], 2]
names(y_bound_data) <- "activity"

# 
# 4. Apply names to the data set
#

# Apply column name
names(subject_bound_data) <- "subject"

# Combine it all into a single data set
merged_data <- cbind(x_bound_data, y_bound_data, subject_bound_data)

# 
# 5. Finished tidy data set for the activities and subjects
# 

tidy_data <- ddply(merged_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidy_data, "tidy_activity_data.txt", row.name=FALSE)

