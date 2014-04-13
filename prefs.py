#!/usr/bin/python
 
# This sample code is for use with Dropbox desktop client
# versions 1.2 and below. It is likely to be deprecated in all
# other future releases. Use it at your own risk.
# Read more at http://www.dropbox.com/developers/desktop_apps
 
import base64
import os.path
import platform
  
if platform.system() == 'Windows':
    HOST_DB_PATH = os.path.expandvars(r'%APPDATA%\Dropbox\host.db')
else:
    HOST_DB_PATH = os.path.expanduser(r'~/.dropbox/host.db')
  
def read_dropbox_location():
    f = open(HOST_DB_PATH, "r")
      
    try:
        ignore = f.readline()
        location_line = f.readline().strip()
        return base64.decodestring(location_line).decode('utf8')
    finally:
        f.close()
  
    raise Exception("Dropbox location not found")
  
if __name__ == '__main__':
    print read_dropbox_location()