# Title: script to find banned files on the system and thier creation date
# Peter Thorpe 2019 University of St Andrews 2019 Nov

import os
import platform
import datetime
import os, time, datetime

def creation_date(path_to_file):
    """
    Try to get the date that a file was created, falling back to when it was
    last modified if that isn't possible.
    See http://stackoverflow.com/a/39501288/1709587 for explanation.
    """
    if platform.system() == 'Windows':
        return os.path.getctime(path_to_file)
    else:
        stat = os.stat(path_to_file)
        try:
            return stat.st_birthtime
        except AttributeError:
            # We're probably on Linux. No easy way to get creation dates here,
            # so we'll settle for when its content was last modified.
            date_created =("Date created: " + time.ctime(created))
            return date_created

  
def modification_date(filename):
    t = os.path.getmtime(filename)
    return datetime.datetime.fromtimestamp(t)


# Run as script
if __name__ == '__main__':
    SUFFIX = ".bam"
    # call the function to get a list of results wanted
    directory = "."
    # get all folder names os.walk(directory)
    for dirpath, subdirs, files in os.walk(directory):
        for x in files:
            #print result
            if x.endswith(SUFFIX):
                banned_file_creation_data = modification_date(os.path.join
                                                              (dirpath, x))
                print(os.path.join(dirpath, x), "\t", \
                      banned_file_creation_data)
                # we can then delete them if they are over a certain age.
                # or email the user to say they are going o be deleted.
