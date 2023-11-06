#!/bin/bash
echo "Beginning $(date)"
echo "Beginning $(date)" >> /home/user/copy_to_remote.log
echo "Removing old files $(date)"
echo "Removing old files $(date)" >> /home/user/copy_to_remote.log

# Deleting all files to leave transfwer directory empty`
rm /home/user/toTransfer/*

# finding and copying all files less than half a day old
echo "Copying files $(date)"
echo "Copying files $(date)" >> /home/user/copy_to_remote.log
find /home/user/BirdSongs/Extracted/By_Date/ -mtime -1 -name '*.wav' -exec cp -u {} /home/user/toTransfer/ \;
find /home/user/BirdSongs/Processed/ -mtime -1 -name '*.wav' -exec cp -u {} /home/user/toTransfer/ \;

echo "Renaming files $(date)"
echo "Renaming files $(date)" >> /home/user/copy_to_remote.log
cd /home/user/toTransfer

# Renaming files to BattyBirdNetPi_yyyymmdd_hhmmss_species.wav
for fileName in *.wav
do
  if [[ $fileName == *birdnet* ]]
    # if file name contain birdnet
    then
      # Make an array of the filename separated by -
      IFS='-' read -ra my_array <<< "$fileName"

      # Count number of array elements
      mycount="${#my_array[@]}"

      if [ $mycount -gt 5 ]
        then
          # If more than 5 array elements
          species="${my_array[0]}"
        else
          # If less than 5 array elements
          species="NoID"
      fi

      # Remove .wav from last elemwent
      my_array["${mycount}-1"]=$(echo "${my_array[${mycount}-1]}" | cut -d'.' -f1)

      # Split filename array up
      mytime=${my_array[${mycount}-1]}
      myday=${my_array[${mycount}-3]}
      mymonth=${my_array[${mycount}-4]}
      myyear=${my_array[${mycount}-5]}

      # Make an array of time split by :
      IFS=':' read -ra my_time <<< "${mytime}"
      myhour="${my_time[0]}"
      myminute="${my_time[1]}"
      mysecond="${my_time[2]}"

      # Rename files
      echo "mv ${fileName} BattyBirdNetPi_${myyear}${mymonth}${myday}_${myhour}${myminute}${mysecond}_${species}.wav"
      echo "mv ${fileName} BattyBirdNetPi_${myyear}${mymonth}${myday}_${myhour}${myminute}${mysecond}_${species}.wav" >> /home/user/copy_to_remote.log
      echo "mv ${fileName} BattyBirdNetPi_${myyear}${mymonth}${myday}_${myhour}${myminute}${mysecond}_${species}.wav" | bash
  fi
done

# Copy files to RemoteSFTPLocation
echo "Cloning to RemoteSFTPLocation $(date)"
echo "Cloning to RemoteSFTPLocation $(date)" >> /home/user/copy_to_remote.log
rclone copy /home/user/toTransfer/ RemoteSFTPLocation:/remoteLocation/ --ignore-errors --ignore-existing --log-file=/home/user/copy_to_remote.log --log-level INFO

# Copy files to LocalSFTPLocation
echo "Cloning to LocalSFTPLocation $(date)"
echo "Cloning to LocalSFTPLocation $(date)" >> /home/user/copy_to_remote.log
rclone copy /home/user/toTransfer/ LocalSFTPLocation:/FromBattyBirdNETPi/ --ignore-errors --ignore-existing --log-file=/home/user/copy_to_remote.log --log-level INFO

echo "Complete"
echo "Complete" >> /home/user/copy_to_remote.log
echo " " >> /home/user/copy_to_remote.log
peter@battyBirdNET-Pi:~$ cat copy_to_remote.sh
