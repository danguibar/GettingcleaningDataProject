# GettingcleaningDataProject
### Codebook - what is this data about and how can it be all pieced together?

test	
     y_test(activity_id 1:6)                                                    ->2947 lines	
     subject_test(person_id  2,4,9,10,12,13,18,20,24)                           ->2947 lines	
     X_test(561 result variables-columns)                                       –>2947 lines	
     subfolder/Inertial Signal(each file is one variable)                       ->2947 lines

training	
     y_train(activity_id 1:6)                                    ->7352 lines	
     subject_train(person_id 1,3,5,6,7,8,11,14,15,16,17,19,
                              21,22,23,25,26,27,28,29,30)        ->7352 lines	
     X_train(561 result variables-columns)                       ->7352 lines
     subfolder_train/Inertial Signal(each file is one column)    ->7352 lines

These are basically two sets of data with the layout.  Files y_test, subject_test, X_test have
same number of rows sugesting a one to one correspondence as to indicating that they could just
be pasted together to get one whole data frame. Once the date is pasted we had a layout that 
could be describe briefly as follows

Each line has next values
column 1                  : activity_id(2947 lines with possible values 1 to 6)  
column 2                  : subject_id( 2947 lines with id of person doing test)  
                           the set of subject_ids in subject_test file is 2,4,9,10,12,13,18,20,24
column 3 upto column 561+2: from X_test file, where each of its values is an observed measure for same activty and individual  :

The training data has the same layout as the testing data with only difference being the number of records(7352).
Each line has next values
column 1                  : activity_id(2947 lines with possible values 1 to 6)  from y_train file
column 2                  : subject_id( 2947 lines with id of person doing test) from subject_train file 
                        the set of subject_ids in subject_train file is 1,3,5,6,7,8,11,14,15,16,17,19
                                                                             21,22,23,25,26,27,28,29,30  
column 3 upto column 561+2: from X_train file, where each of its values is an observed measure for same activty and individual  :




