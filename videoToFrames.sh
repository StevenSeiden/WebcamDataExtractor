FILENAME=$1

ffmpeg -i $FILENAME videoFrame%04d.jpg -hide_banner
