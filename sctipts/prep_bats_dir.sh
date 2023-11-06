# /bin/bash

# With each file in the directory
for fileName in *.wav
do
   # Readthe filename into an array
   IFS='_' read -ra my_array <<< "$fileName"
   # Remove .* from each array field`
   my_array[0]=$(echo "${my_array[0]}" | cut -d'.' -f1)
   my_array[1]=$(echo "${my_array[1]}" | cut -d'.' -f1)
   my_array[2]=$(echo "${my_array[2]}" | cut -d'.' -f1)

   # Check for filename format to see if it is of the correct/incorrect format
   # Correct format is YYYYMMDD_HHMMSS_SPECIES.wav
   if [[ ${my_array[0]} =~ ^[0-9]+$ ]]; then
      # filename is alrteady in the correct format
      echo "$fileName is in the correct format"
      newfilename="${fileName}"
   else
      # filename is in the incorrect format
      # Create the correct format
      newfilename="${my_array[1]}_${my_array[2]}_${my_array[0]}.wav"
      # Rename file
      echo "$fileName renamed to ${newfilename}"
      echo "mv \"$fileName\" \"${newfilename}\"" | bash
  fi

  echo .
  echo $newfilename
  # Read the existing GUANO metadata and put it into a file
  guano_dump.py ${newfilename} > guano.txt

  # Check if the phrase 'Loc Position:' does not exist in the current metadata
  if ! grep 'Loc Position:' guano.txt;
    then
    # Position does not exist
    echo "GUANO location not found"

    # Get location data from GPX base table
    location=$(wget http://<webservice that takes file name, works out timestamp and returns loaction as 'lat long'>?filename=${newfilename} -q -O -)

    # Perform injection of location data into GUANO metadata - this does not work yet - format unknown
    echo "guano_edit.py 'GUANO|Version: 1.0' 'Loc Position: ${location}' 'Note: Location from GPX file' ${newfilename}"
    echo "guano_edit.py 'GUANO|Version: 1.0' 'Loc Position: ${location}' 'Note: Location from GPX file' ${newfilename}" | bash
  fi
done
