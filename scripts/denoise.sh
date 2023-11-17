#!/bin/bash

# Create a shifted frequency / pitch wav file
sox -v 4 ${1} ${1%.*}_shifted.wav speed 0.05 stretch 0.05

# Create a shifted and slowed frequency / pitch wav file
sox -v 4 ${1} ${1%.*}_shifted_slowed.wav speed 0.1

# Create a noise segment out of the first 0.9 seconds of the shifted frequency / pitch wav file
sox ${1%.*}_shifted.wav noise-audio.wav trim 0 0.900

# Create a noise segment out of the first 9 seconds of the shifted and slowed frequency / pitch wav file
sox ${1%.*}_shifted_slowed.wav noise-audio-slowed.wav trim 0 9

# Create a noise profile from the noise segment out of the first 0.9 seconds of the shifted frequency / pitch wav file
sox noise-audio.wav -n noiseprof noise.prof

# Create a noise profile from the noise segment out of the first 9 seconds of the shifted and slowed frequency / pitch wav file
sox noise-audio-slowed.wav -n noiseprof noise-slowed.prof

# Create a de-noised wav file using the noise profile
sox "${1%.*}_shifted.wav" "${1%.*}_nonoise_shifted.wav" noisered noise.prof 0.21
sox "${1%.*}_shifted_slowed.wav" "${1%.*}_nonoise_shifted_slowed.wav" noisered noise-slowed.prof 0.21

# Delete intermediate files
rm noise-audio*.wav
rm noise*.prof
#rm ${1%.*}_shifted.wav
#rm ${1%.*}_shifted_slowed.wav
