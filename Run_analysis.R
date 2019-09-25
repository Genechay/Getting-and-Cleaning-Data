
#Download data 
download.file(url='https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',destfile='localfile.zip', method='curl',mode = 'wb')

#Unzip dataset
unzip(zipfile="./Localfile.zip",exdir="./Week4")


#unzip files in the working directory
list.files("D:/NE/BNP_DATA_AGILE_Course/Data_CleanUp/Week4")

#define dataset in working directory
pathdata = file.path("D:/NE/BNP_DATA_AGILE_Course/Data_CleanUp/Week4", "UCI HAR Dataset")
files = list.files(pathdata, recursive=TRUE)
files

#Reading training tables - xtrain / ytrain, subject train
xtrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)

#Reading the testing tables
xtest = read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)

#Read the features data
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)

#Read activity labels data
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

#Create Sanity and Column Values to the Train Data
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"

#Create Sanity and column values to the test data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"

#Create sanity check for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')

#Merging the train and test data - important outcome of the project
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)

#Create the main data table merging both table tables - this is the outcome of 1
setAllInOne = rbind(mrg_train, mrg_test)

# Need step is to read all the values that are available
colNames = colnames(setAllInOne)

#Need to get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))

#A subtset has to be created to get the required dataset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

# Create new set of file 
readySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
readySet <- readySet[order(readySet$subjectId, readySet$activityId),]

#write the ouput to a text file 
write.table(readySet, "readySet.txt", row.name=FALSE)
