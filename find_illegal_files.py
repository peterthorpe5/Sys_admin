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
import os, time, datetime

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

def sizeof_fmt(num, suffix='B'):
    """func to return human readble file sizes"""
    for unit in ['','K','M','G','T','P','E','Z']:
        if abs(num) < 1024.0:
            return "%3.1f%s%s" % (num, unit, suffix)
        num /= 1024.0
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
        for x in files:
            #print result
            for filetype in illegal_files:
                if x.endswith(filetype):
                    try:
                        file_date = modification_date(os.path.join
                                                     (dirpath, x))
                        file_size = get_size(os.path.join(dirpath, x))
                        outfmt = "\t".join([(os.path.join(dirpath, x)),
                                            str(file_date), 
                                            file_size])         
                        outfile_dict[filetype].write(outfmt  + "\n")
                    except:
                        pass # probaly been altered during running
