# BattyBirdNET-Utils

Pre requisites
1) Python
2) guano-py (https://github.com/riggsd/guano-py)
3) Web service that you can pass a formatted filename YYYYMMDD_HHMMSS_SPECIES.wav and can return the location in the format 'latitude longitude' or blank if no location exists.
Modify the following line to the web service between the < and >
http://<webservice that takes file name, works out timestamp and returns loaction as 'lat long'>?filename=${newfilename}
