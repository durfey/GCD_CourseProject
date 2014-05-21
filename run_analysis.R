## We begin by downloading and unzipping the data.
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="dataset.zip")
unzip("dataset.zip")

## We read in the relevant data and bind them together to create one dataframe.
xTest<-read.table("UCI HAR Dataset/test/X_test.txt",stringsAsFactors=FALSE)
subjTest<-read.table("UCI HAR Dataset/test/subject_test.txt",stringsAsFactors=FALSE)
activityTest<-read.table("UCI HAR Dataset/test/y_test.txt",stringsAsFactors=FALSE)
cbtest<-cbind(subjTest,activityTest,xTest)

xTrain<-read.table("UCI HAR Dataset/train/X_train.txt",stringsAsFactors=FALSE)
subjTrain<-read.table("UCI HAR Dataset/train/subject_train.txt",stringsAsFactors=FALSE)
activityTrain<-read.table("UCI HAR Dataset/train/y_train.txt",stringsAsFactors=FALSE)
cbtrain<-cbind(subjTrain,activityTrain,xTrain)

xTT<-rbind(cbtest,cbtrain) ## Now we have one dataframe that includes both the test and train data.
rm(xTest)
rm(xTrain)

## Here we read in the variable names from the features data.
features<-read.table("UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)

## Now, we begin to clean up the variable names a bit.
noParenth<-gsub(pattern="\\(|\\)",x=features[,2],replacement="")
hyphOut<-gsub(pattern="-",x=noParenth,replacement="")

## We want to end up with only the variables that correspond to mean or std, so here we determine the numbers of those columns, so that we may specifically select them later.
## Note: the variables with "meanFreq" are filtered out, because it is not a mean of a measurement, but just of a frequency.
meanCol<-grep(pattern="mean",hyphOut)
stdCol<-grep(pattern="std",hyphOut)
feat<-features[c(meanCol,stdCol),]
noFreq<-grep(pattern="Freq",feat[,2],invert=TRUE)
featNoFreq<-feat[noFreq,]
featCol<-featNoFreq[,1]   ## the column numbers that correspond to mean/std

## Here is some more clean-up of the variable names. For consistency, we have removed the dots and ended up with capitalized letters that start each relevant word.
meanCapX<-gsub(pattern="mean",hyphOut,replacement="Mean")
meanCapY<-gsub(pattern="mean",meanCapX,replacement="Mean")
meanCapZ<-gsub(pattern="mean",meanCapY,replacement="Mean")
stdCapX<-gsub(pattern="std",meanCapZ,replacement="Std")
stdCapY<-gsub(pattern="std",stdCapX,replacement="Std")
stdCapZ<-gsub(pattern="std",stdCapY,replacement="Std")

## Naming the columns of the merged dataset.
colnames(xTT)<-c("subject","activity",stdCapZ)
x<-xTT[,c(1,2,featCol+2)]

## Lastly, we merge in the activity names that correspond to the appropriate activity numbers.
activityLabels<-read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activityLabels)<-c("activity","activityName")
xAll<-merge(activityLabels,x,by="activity")  ## the full dataset as a dataframe!


## Now that we have all the appropriate data in one dataframe, we may run some analysis on it and output a tidy dataset with appropriate information.
## We will use the 'melt' and 'dcast' functions that are found in the 'reshape2' package. This is due to the ease and effiency of which using these methods are to find our desired result, namely, the mean of each measurement variable.
##install.packages("reshape2")
##library(reshape2)

xAllMelt<-melt(xAll,id=c("subject","activity","activityName"),measure.vars=colnames(xAll[,4:69]))
tidyAsHell<-dcast(xAllMelt,subject + activityName ~ variable,mean)

## In order to output this nice and tidy dataframe to a file that we can upload, we will write it to a .txt file, which will drop in our working directory for easy access.
write.table(tidyAsHell,file="tidy.txt")
