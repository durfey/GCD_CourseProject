===========================================
## Getting and Cleaning Data Course Project
===========================================

The data used to create the tidy dataset that is included in this same repository
on Github is from the following:

-------------------------------------------

Human Activity Recognition Using Smartphones Dataset
Version 1.0

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

-------------------------------------------

The methods and reasoning used to create the tidy dataset that is exhibited in 
'tidy.txt' and produced by the 'run_analysis.R' code are outlined below.

The various files relevant to the data of interest is first downloaded and unzipped
using the 'download.file' and 'unzip' functions. These are straightforward and do
not require further explanation.

Next, the data of interest are read using 'read.table'. The files 'X_test.txt',
'subject_test.txt', and 'y_test.txt' are column-bound together to represent all
of the test data needed. The train data files are read and column-bound in the
same fashion. Once both test and train dataframes are complete, they are row-bound
into a single dataframe.

The 'features.txt' file represents the data we will need to create the appropriate
column names for our newly created dataframe. We read in the file and use 'gsub'
functions to clean out inappropriate symbols such as parentheses and periods.

We want to end up with only the variables that correspond to mean or std, so next
we determine the numbers of those columns that we may specifically select
them later. The 'grep' function is very useful in recognizing patterns and returning
the row number in which it is found (which will correspond to column number later).
Note that the variables with 'meanFreq' in the name are filtered out, because it
is not a mean of a particular measurement, but just of a frequency.

What follows next is further cleanup of variable names in order to create a uniform
naming scheme using 'gsub'. The variable naming scheme that we have chosen here 
is that of Camel Case with a lower-case initial letter. This is consistent with
accepted methods outlined in Google's R Style Guide. For reference, the guide
may be found here: https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml
Note: Google's most preferred naming scheme of all lower-case letters with words
separated by dots was rejected for the modified Camel Case scheme due to concerns
of variable name length.

The cleaned variable names, along with appropriate names for 'subject' and 'activity'
are then placed into the dataframe using 'colnames'. We then select the desired
columns that refer to mean and std (along with subject and activity of course).

Lastly, we read in and merge in the activity names that correspond to the
appropriate activity numbers. This completes our dataframe to include all data
that we will be interested in.

After the complete dataset is created, we may run our analysis on it and output
a tidy dataset with our desired information: the mean of each measurement for
each subject performing each activity. We use the 'melt' and 'dcast' functions
that are found in the 'reshape2' package. This is due to the ease and efficiency
these methods provide in order to find our desired results.

The dataframe that is created using 'melt' and 'dcast' has 180 observations, which
correspond to each of the 30 subjects undertaking each of the 6 activities. The
mean of each measurement variable for each observation may then be found in the
remaining 66 columns to the right of the subject and activity names.

The tidy dataset is then written to a text file using 'write.table' and it is
deposited into the working directory.

Thank you very much for your time and patience in reading all of this!