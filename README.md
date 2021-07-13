# Webcam data extractor
This project aims to extract data from a user's webcam to find any possible security implications of having your camera on during a video conference. Possible data includes the user's cursor position and answers to polls held through platforms such as Zoom.

To start/stop recording data, press `r`. To quit, press `q`.

The Python script records at 5 FPS and is made possible by Antoine Lamé's [Gaze Tracking library.](https://github.com/antoinelame/GazeTracking) This application currently records the user's gaze position as (x,y) coordinates as well as the user's cursor position.
