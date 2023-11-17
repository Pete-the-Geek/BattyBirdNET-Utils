#!/bin/bash

# Clearing out old import
echo
echo Clearing out old import if it exists
rm -r ./*/ 2> /dev/null

# Initialise Images directory
echo
echo Creating Images Directory for Spectograms
mkdir images

# With each file in the directory
echo
echo Renaming Files and Create Spectograms
for fileName in *.wav
do
   echo
   echo $fileName                                                                                                                                                         
   # Readthe filename into an array
   IFS='_' read -ra my_array <<< "$fileName"
   # Remove .* from each array field`
   my_array[0]=$(echo "${my_array[0]}" | cut -d'.' -f1)
   my_array[1]=$(echo "${my_array[1]}" | cut -d'.' -f1)
   my_array[2]=$(echo "${my_array[2]}" | cut -d'.' -f1)

   # Check for filename format to see if it is of the correct/incorrect format
   if [[ ${my_array[0]} =~ ^[0-9]+$ ]]; then
      # filename is alrteady in the correct format
      newfilename="${fileName}"
      title="${my_array[2]}"
   else
      # filename is in the incorrect format
      # Create the correct format
      newfilename="${my_array[1]}_${my_array[2]}_${my_array[0]}.wav"
      title="${my_array[0]}"
      # Rename file
      echo "$fileName renamed to ${newfilename}"
      echo "mv \"$fileName\" \"${newfilename}\"" | bash
  fi

  # Create Spectogram image
  echo Creating Spectogram
  sox "$newfilename" -n spectrogram -t "${title}" -c "${newfilename}" -o "images/${newfilename}.png"

  # This is not used now but it is to create a preparatory directory of files to be import into BattyBirdNET-Pi
  battyBirdNetFileFormat="${newfilename:0:4}-${newfilename:4:2}-${newfilename:6:2}-birdnet-${newfilename:9:2}:${newfilename:11:2}:${newfilename:13:2}.wav"
  ##  echo "cp \"${newfilename}\" \"./toPi/${battyBirdNetFileFormat}\"" | bash

  echo injecting GUANO if necessary
  # Read the existing GUANO metadata and put it into a file
  guano_dump.py ${newfilename} > guano.txt

  # Check if the word position does not exist in the current metadata
  if ! grep 'Loc Position:' guano.txt;
    # Position does not exist
    then
    echo "Guano location not found"

    # Get location data from GPX base table
    location=$(wget http://<webservice that takes file name, works out timestamp and returns loaction as 'lat long'>?filename=${newfilename} -q -O -)

    if [ -n "${location}" ]
      then
      # Perform injection of location data into GUANO metadata - this does not work yet - format unknown
      echo "guano_edit.py 'GUANO|Version: 1.0' 'Loc Position: ${location}' 'Note: Location from GPX file' ${newfilename}"
      echo "guano_edit.py 'GUANO|Version: 1.0' 'Loc Position: ${location}' 'Note: Location from GPX file' ${newfilename}" | bash
    fi
  fi
done

# Deleting GUANO_BACKUP files and folders
echo
echo Deleting GUANO_BACKUP directory
find ./ -name 'GUANO_BACKUP*' -exec rm -R {} \;

# Create output directory
echo
echo Creating output directory
IFS='/' read -ra my_array <<< $(pwd)
echo mkdir -p "/home/user/Desktop/files/Recordings/${my_array[${#my_array[@]} - 2]}/${my_array[${#my_array[@]} - 1]}"
mkdir -p "/home/user/Desktop/files/Recordings/${my_array[${#my_array[@]} - 2]}/${my_array[${#my_array[@]} - 1]}"

# Process bat files
echo
echo Processing WAV files for Bat Detections
echo python3 bat_ident.py --area UK --i $(pwd) --o "/home/user/Desktop/files/Recordings/${my_array[${#my_array[@]} - 2]}/${my_array[${#my_array[@]} - 1]}" --min_conf 0.1 --overlap 0 --rtype csv --threads 4 --sensitivity 0.5
python3 /home/user/battyBirdNET-Analyzer/bat_ident.py --area UK --i $(pwd) --o "/home/user/Desktop/files/Recordings/${my_array[${#my_array[@]} - 2]}/${my_array[${#my_array[@]} - 1]}" --min_conf 0.1 --overlap 0 --rtype csv --threads 1 --sensitivity 0.5

echo
echo Copying resuts
cp "/home/user/Desktop/files/Recordings/${my_array[${#my_array[@]} - 2]}/${my_array[${#my_array[@]} - 1]}Results.csv" ./

echo
echo Finished
echo
