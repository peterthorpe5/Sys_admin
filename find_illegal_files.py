# Title: script to find banned files on the system and thier creation date
# Script to find "illegal files" on our cluster
# because I cam fed up of askin guser to delete data,
# which they never do. 
# I found over 1000 sam files. 
# 5 year old bam files ... feel my pain. 
# author Peter Thorpe
# Peter Thorpe 2019 University of St Andrews 2019 Nov

import os
import platform
import datetime
import time

illegal_files=""".bam .sam .fq .fastq""".split()

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
            # We're probably on Linux. 
            # No easy way to get creation dates here,
            # so we'll settle for when its content was last modified.
            dc =("Date created: " + time.ctime(created))
            return dc

def sizeof_fmt(num, suffix='B', min_file_size=100):
    """func to return human readble file sizes"""
    original_num = num
    #if num < min_file_size:
        #return "small file"
    for unit in ['','K','M','G','T','P','E','Z']:
        if abs(num) < 1024.0:
            return "%3.1f%s%s" % (num, unit, suffix)
        num /= 1024.0
    print(original_num, "%.1f%s%s" % (num, 'Yi', suffix))
    return "%.1f%s%s" % (num, 'Yi', suffix)


def get_size(infile):
    """func to get the size of the file"""
    return sizeof_fmt(os.path.getsize(infile))
  
  
def modification_date(filename):
    t = os.path.getmtime(filename)
    return datetime.datetime.fromtimestamp(t)
    
# Run as script
if __name__ == '__main__':
    # call the function to get a list of results wanted
    directory = "."
    # get all folder names os.walk(directory)
    outfile_dict = dict()
    for filetype in illegal_files:
        filetype_out = "illegal%s.txt" % (filetype)
        filetype_out = open(filetype_out, "w")
        outfile_dict[filetype] = filetype_out
    for dirpath, subdirs, files in os.walk(directory):
        if "software_backups" in dirpath:
            continue
        for x in files:
            #print result
            for filetype in illegal_files:
                if x.endswith(filetype):
                    #if not os.path.isfile(os.path.join(dirpath, x)):
                        #continue # may have been modified while running
                    file_date = modification_date(os.path.join
                                                 (dirpath, x))
                    file_size = get_size(os.path.join(dirpath, x))
                    #if file_size == "small file":
                        #continue
                    outfmt = "\t".join([(os.path.join(dirpath, x)),
                                        str(file_date), 
                                        file_size])
                                        
                    #if "MB" in file_size or "KB" in file_size:
                        #continue
                    outfile_dict[filetype].write(outfmt  + "\n")
    for filetype in illegal_files:
        # its polite to flush the toilet after yourself. 
        outfile_dict[filetype].close()
