# BattyBirdNET-Utils

scripts/prep_bats_dir.sh

This needs to be run from the directory with the bat WAV files and will rename the files from SPECIES_YYYYMMDD_HHMMSS.wav as produced by Wildlife Acoustics Echo Meter application and saves them as YYYYMMDD_HHMMSS_SPECIES.wav
It then checks the GUANO Metadata to check if it contains location information, used by many post proceesing analysis applications like BTO Acoustic Pipeline.

Pre requisites
1) Python
2) guano-py (https://github.com/riggsd/guano-py)
3) Web service that you can pass a formatted filename YYYYMMDD_HHMMSS_SPECIES.wav and can return the location in the format 'latitude longitude' or blank if no location exists.
Modify the following line to the web service between the < and >
http://<webservice that takes file name, works out timestamp and returns loaction as 'lat long'>?filename=${newfilename}
