##This function processes data from a UCI machine learning repository downloaded from
##http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
##The function assumes the data has been downloaded and unzipped within R's current working directory.

run_analysis <- function(){
        root <- getwd()                                                                 #get working directory
        fp_ytrain <- paste(root,"/UCI HAR Dataset/train/y_train.txt",sep = "")          #create filepath for training activity
        fp_xtrain <- paste(root,"/UCI HAR Dataset/train/X_train.txt",sep = "")          #create filepath for training data
        fp_subject <- paste(root, "/UCI HAR Dataset/train/subject_train.txt",sep = "")  #create filepath for trainign subject id
        T_subject <- read.csv2(fp_subject, sep = "", header = FALSE, stringsAsFactors = FALSE)
                                                                                        #Read training subjects into dataframe
        T_data <- read.csv2(fp_xtrain, sep = "", header = FALSE, colClasses = "character")                        
                                                                                        #Read training data into dataframe
        T_activity <- read.csv2(fp_ytrain, sep = "", header = FALSE, stringsAsFactors = FALSE)
                                                                                        #Read training activity into dataframe
        fp_features_labels <- paste(root, "/UCI HAR Dataset/features.txt", sep = "")    #create filepath for feature labels
        features.label <- read.csv2(fp_features_labels, sep = "", header = FALSE)       #Read training feature labels into dframe
        
        colnames(T_data) <- features.label$V2                                           #Xfer colnames to main dframe
        colnames(T_subject) <- "subject"                                                #Rename training subject column
        colnames(T_activity) <- "activity"                                              #Rename training activity column
        T_data <- cbind(T_data, T_subject, T_activity)                                  #Bind columns of training data 
        
        fp_ytest <- paste(root,"/UCI HAR Dataset/test/y_test.txt",sep = "")             #create filepath for test activity
        fp_xtest <- paste(root, "/UCI HAR Dataset/test/X_test.txt",sep = "")            #create filepath for test data
        fp_tsubject <- paste(root, "/UCI HAR Dataset/test/subject_test.txt",sep = "")   #create fileplath for test subject id
        Tst_subject <- read.csv2(fp_tsubject, sep="", header = FALSE, stringsAsFactors = FALSE)                   
                                                                                        #Read test subject data into datframe
        Tst_data <- read.csv2(fp_xtest, sep = "", header = FALSE, colClasses = "character")                       
                                                                                        #Read test data into dataframe
        Tst_activity <- read.csv2(fp_ytest, sep = "", header = FALSE, stringsAsFactors = FALSE)                   
                                                                                        #Read test activity into dataframe
        
        colnames(Tst_data) <- features.label$V2                                         #Xfer colnames to test dataframe
        colnames(Tst_subject) <- "subject"                                              #Rename test subject column
        colnames(Tst_activity) <- "activity"                                            #Rename test activity column
        Tst_data <- cbind(Tst_data, Tst_subject, Tst_activity)                          #Bind columns of test data
        
        T_data <- rbind(T_data,Tst_data)                                                #Bind rows of test and training data
        myIndex <- grep("mean|std|subject|activity|Mean",colnames(T_data))              #Identify columns with mean and std data
        T_data <- T_data[,myIndex]                                                      #Extract columns by myIndex
        T_data$activity <- as.character(T_data$activity)                                #Convert activity column to charater type
        
        T_data$activity <- sub("1","walking",T_data$activity)                           #Convert activities to descriptive labels
        T_data$activity <- sub("2","walking_upstairs",T_data$activity)
        T_data$activity <- sub("3","walking_downstairs",T_data$activity)
        T_data$activity <- sub("4","sitting",T_data$activity)
        T_data$activity <- sub("5","standing",T_data$activity)
        T_data$activity <- sub("6","laying",T_data$activity)
        MyCols <- grepl("subject|activity",colnames(T_data))                            #Index column names for numeric conversion
        T_data[!MyCols] <- lapply(T_data[!MyCols],as.double)                            #Convert numeric data to type double                            
        T_data$activity <- factor(T_data$activity, c("walking","walking_upstairs",
                                                     "walking_downstairs","sitting",
                                                     "standing","laying"), ordered = TRUE) 
                                                                                        #Convert activity to factors
        library(reshape2)                                                               #load reshape2 package
        TidyT <- melt(T_data, id.vars = c("subject","activity"))                        #create tidy data set by melting
        library(dplyr)                                                                  #load dplyr package
        TidyT <- group_by(TidyT,variable,activity,subject)                              #Provide grouping for tidy data
        TidyT <- summarize(TidyT, mean(value))                                          #Summarize tidy data set
        TidyT <- ungroup(TidyT)                                                         #Remove grouping
        TidyT                                                                           #Return tidy data set
        

}