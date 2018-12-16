@echo off

REM youtube-clip-fader.bat
REM Downloads, clips, and fades a YouTube video
REM TJ Couch

REM Follow along with the example inputs to get a sample clip 18 seconds long with a one-second fade on each end

REM get video id
REM ex: tMwhl4IrPNc
set /p VID=Enter Video ID: 

REM download the file or playlist
SET start=https://www.youtube.com/watch?v=
SET url=%start%%VID%

youtube-dl --extract-audio --audio-format wav --audio-quality 0 --yes-playlist -o %%(id)s.%%(ext)s %url%

REM get start and end times
REM ex: 00:31
set /p START=Enter clip start time MM:SS[.DD]: 
REM ex: 00:49
set /p END=Enter clip end time MM:SS[.DD]: 

REM trim the file down to size
ffmpeg -i %VID%.wav -ss 00:%START% -to 00:%END% -c copy %VID%trim.wav

REM get the length of the clip
ffprobe -i %VID%trim.wav -show_entries stream=codec_type,duration -of compact=p=0:nk=1

REM get fade times
REM ex: 1
set /p FADEIN=Enter fade in duration in seconds: 
REM ex: 17
set /p FADEOUTS=Enter fade out start time in seconds: 
REM ex: 1
set /p FADEOUTD=Enter fade out duration in seconds: 

REM filter fade in and out
ffmpeg -i %VID%trim.wav -af "afade=t=in:st=0:d=%FADEIN%,afade=t=out:st=%FADEOUTS%:d=%FADEOUTD%" %VID%clip.wav

REM remove temp files
del %VID%.wav
del %VID%trim.wav