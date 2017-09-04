
# download the folder to local computer and set as working directory
setwd("~/R/GettingandCleaningData")


# read files and assign column names
features <- read.table("./features.txt",header=FALSE)

activityLabel <- read.table("./activity_labels.txt",header=FALSE)
colnames(activityLabel)<-c("activityId","activity")

subjectTrain <-read.table("./train/subject_train.txt", header=FALSE)
colnames(subjectTrain) <- "subjectId"

xTrain <- read.table("./train/X_train.txt", header=FALSE)
colnames(xTrain) <- features[,2]

yTrain <- read.table("./train/y_train.txt", header=FALSE)
colnames(yTrain) <- "activityId"

# combine the train data
train <- cbind(yTrain,subjectTrain,xTrain)

# repeat the same process for test data

subjectTest    <-read.table("./test/subject_test.txt", header=FALSE)
colnames(subjectTest) <- "subjectId"

xTest         <- read.table("./test/X_test.txt", header=FALSE)
colnames(xTest) <- features[,2]

yTest         <- read.table("./test/y_test.txt", header=FALSE)
colnames(yTest) <- "activityId"

# combine all the test Data
test <- cbind(yTest,subjectTest,xTest)


# append the train and test datasets

data <- rbind(train,test)

# Q2 extract only columns that contain mean or std
data2 <-data[,grepl("mean|std|activityId|subjectId",colnames(data))]

# Q3 Uses descriptive activity names to name the activities in the data set
data3 <- merge(x= data2, y= activityLabel, by="activityId", all.x= TRUE)
head(colnames(data3),4)

# Q4 Appropriately labels the data set with descriptive variable names.
names(data3) <- gsub("\\(|\\)", "", names(data3), perl  = TRUE)
names(data3) <- gsub("^t", "Time", names(data3))
names(data3) <- gsub("BodyBody", "Body", names(data3))

# Q5 creates data set with the average of each variable for each activity and each subject.

tidydata<- ddply(data3, c("subjectId","activity"), numcolwise(mean))
write.table(tidydata, file = "./tidydata.txt")
