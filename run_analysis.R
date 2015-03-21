library(data.table)
library(dplyr)
library(plyr)
base_folder<-"UCI\ HAR\ Dataset"
setwd("/Users/dahome/Documents/courseraClasses/machineLearningLine/GettingNCleaningData/project");
files_list <- list.files(base_folder, full.names=TRUE)
#make sure we are reading right files.
for (i in seq_along(files_list)) {                                
  cat(paste(files_list[i]),  "\n");
}
#prepare pathname files and get ready to read them in
measures_561_col_names           <-paste(base_folder,"/features.txt",sep="")
activity_names_by_id_file           <-paste(base_folder,"/activity_labels.txt",sep="")

test_activity_ids_col_file          <-paste(base_folder,"/test/y_test.txt",sep="")
test_person_ids_col_file            <-paste(base_folder,"/test/subject_test.txt",sep="")
test_person_561_col_measures_file   <-paste(base_folder,"/test/X_test.txt",sep="")

train_activity_ids_col_file         <-paste(base_folder,"/train/y_train.txt",sep="")
train_person_ids_col_file           <-paste(base_folder,"/train/subject_train.txt",sep="")
train_person_561_col_measures_file  <-paste(base_folder,"/train/X_train.txt",sep="")

#loadrows<-5
#skiprows<-7345
loadrows<--1
skiprows<-0
activity_names_by_id         <- read.table(activity_names_by_id_file,col.names=c("ActivityId","Activity"))

test_activities_id_column    <-read.table(test_activity_ids_col_file,nrows=loadrows)
test_person_id_column        <-read.table(test_person_ids_col_file,nrows=loadrows)
test_561_measures_columns    <-read.table(test_person_561_col_measures_file,nrows=loadrows)

train_activities_id_column   <-read.table(train_activity_ids_col_file,nrows=loadrows,skip=skiprows)
train_person_id_column       <-read.table(train_person_ids_col_file,nrows=loadrows,skip=skiprows)
train_561_measures_columns   <-read.table(train_person_561_col_measures_file,nrows=loadrows,skip=skiprows)

xcolnames<-data.frame()
mycolnames<-read.table(measures_561_col_names,colClasses=c("character"),stringsAsFactors=FALSE)
names(mycolnames)<-c("COL1","COL2")

arow<-data.frame(COL1="1",COL2="ActivityId"); arow2<-data.frame(COL1="2",COL2="SubjectId")
arow3<-data.frame(COL1="3",COL2="Activity");
xcolnames<-rbind(xcolnames,arow); xcolnames<-rbind(xcolnames,arow2); 
xcolnameswithAct<-rbind(xcolnames,arow3)

xcolnames<-rbind(xcolnames,mycolnames);
  xcolnameswithAct<-rbind(xcolnames,mycolnames)
xcolnamescha<-as.character(xcolnames$COL2)
  xcolnameswithActCha<-as.character(xcolnameswithAct$COL2)

#1. merge data
myDTtest  <-data.table(test_activities_id_column,test_person_id_column,test_561_measures_columns)
myDTtrain <-data.table(train_activities_id_column,train_person_id_column,train_561_measures_columns)


setnames(myDTtest,xcolnamescha)
setnames(myDTtrain,xcolnamescha)

totData<-rbind(myDTtest,myDTtrain) #merged data in totData

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 

filteredMeanStd<- select(totData,grep("ActivityId|SubjectId|std|mean",names(totData),ignore.case = TRUE))

filteredMeanStd<-tbl_df(filteredMeanStd)
#3. Uses descriptive activity names to name the activities in the data set

filteredMeanStd <- tbl_df(left_join(filteredMeanStd,activity_names_by_id,by="ActivityId",match="first"))
filteredMeanStd <- filteredMeanStd[,-1]


#4.Appropriately labels the data set with descriptive variable names.
names(filteredMeanStd) <- gsub('Acc',"Acceleration",names(filteredMeanStd))
names(filteredMeanStd) <- gsub('GyroJerk',"AngularAceleration",names(filteredMeanStd))
names(filteredMeanStd) <- gsub('Gyro',"AngularSpeed",names(filteredMeanStd))
names(filteredMeanStd) <- gsub('^t',"time.",names(filteredMeanStd))
names(filteredMeanStd) <- gsub('^f',"frequency",names(filteredMeanStd))
names(filteredMeanStd) <- gsub('\\(|\\)|-',"",names(filteredMeanStd))
names(filteredMeanStd) <- gsub('std',"StandardDev",names(filteredMeanStd))
names(filteredMeanStd) <- gsub('mean',"Mean",names(filteredMeanStd))

#5. From the data set in step 4, creates a second, 
#   independent tidy data set with the average of each variable for each activity and each subject

averagesPerVariableByActivityNsubjectId <- ddply(filteredMeanStd,c("SubjectId","Activity"),numcolwise(mean))

write.table(averagesPerVariableByActivityNsubjectId,"myTidydata.txt",row.name=FALSE)
