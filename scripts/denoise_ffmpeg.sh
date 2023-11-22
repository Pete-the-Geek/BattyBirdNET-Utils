#!/bin/bash

# Build array of the file location provided
IFS='/' read -ra my_array <<< "${1}"
new_dir=''
filename=${my_array[-1]}

# manually set shifted directory
new_dir=/path/to/new/dir/

# Create shifted directory
echo "Creating shifted directory ${new_dir}"
mkdir -p "${new_dir}"/shifted/

# Process WAV file
echo "Processing WAV file(s)"
ffmpeg -i ${1} -filter:a "volume=4,asetrate=256000*0.05" -y ${new_dir}/shifted/${filename%.wav}_shifted_slowed.wav
ffmpeg -i ${1} -filter:a "volume=4,asetrate=256000*0.05,atempo=2,atempo=2,atempo=2,atempo=10/8" -y ${new_dir}/shifted/${filename%.wav}_shifted.wav
ffmpeg -i ${1} -filter:a "volume=4,asetrate=256000*0.05,afftdn=nr=50:nf=-30" -y ${new_dir}/shifted/${filename%.wav}_nonoise_shifted_slowed.wav
ffmpeg -i ${1} -filter:a "volume=4,asetrate=256000*0.05,atempo=2,atempo=2,atempo=2,atempo=10/8,afftdn=nr=50:nf=-30" -y ${new_dir}/shifted/${filename%.wav}_nonoise_shifted.wav
