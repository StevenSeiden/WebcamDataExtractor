import cv2
import math
import sys
from pynput.mouse import Button, Controller
from gaze_tracking import GazeTracking

gaze = GazeTracking()
videoInput = sys.argv[1] if len(sys.argv) > 1 else 0
webcam = cv2.VideoCapture(videoInput)
fps = webcam.get(cv2.CAP_PROP_FPS)
mouse = Controller()
output = open("output.txt", "w")
recordData = True

width = int(webcam.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(webcam.get(cv2.CAP_PROP_FRAME_HEIGHT))

writer = cv2.VideoWriter('output.mp4', cv2.VideoWriter_fourcc(*'DIVX'), 20, (width, height))

pixelsBetweenEyes = 0
userDistanceFromCam = 0


while True:
    # We get a new frame from the webcam
    ret, frame = webcam.read()

    # We send this frame to GazeTracking to analyze it
    gaze.refresh(frame)

    frame = gaze.annotated_frame()
    text = ""

    cv2.putText(frame, text, (90, 60), cv2.FONT_HERSHEY_DUPLEX, 1.6, (147, 58, 31), 2)

    currentMousePos = mouse.position

    if gaze.pupils_located:
        pixelsBetweenEyes = math.sqrt((gaze.pupil_right_coord_x() - gaze.pupil_left_coord_x()) ** 2 + (gaze.pupil_right_coord_y() - gaze.pupil_left_coord_y()) ** 2)
        userDistanceFromCam = 128.4 / pixelsBetweenEyes

    # Drawing arrow in corner
    if gaze.horizontal_ratio() is not None and gaze.vertical_ratio() is not None:
        cv2.arrowedLine(frame, (100, 100), (int(gaze.horizontal_ratio() * 200), int(-50 + gaze.vertical_ratio() * 200)),
                        (0, 255, 0), 9)
    cv2.putText(frame, "Dist: " + str(userDistanceFromCam) + "m", (90, 165), cv2.FONT_HERSHEY_DUPLEX, 0.9, (0, 255, 0), 2)
    cv2.putText(frame, "Gaze pos: (" + str(gaze.horizontal_ratio()) + "," + str(gaze.vertical_ratio()) + ")", (90, 195), cv2.FONT_HERSHEY_DUPLEX, 0.9, (0, 255, 0), 2)

    # Outputting data when recording
    if recordData:
        # Outputting -> x gaze position, y gaze position, user's distance from camera, x cursor position, y cursor position
        output.write(
            str(gaze.horizontal_ratio()) + "," + str(gaze.vertical_ratio()) + "," + str(userDistanceFromCam) + "," + str(currentMousePos[0]) + "," + str(
                currentMousePos[1]) + "\n")
        cv2.circle(frame, (width-100, 50), 30, (0, 0, 255), -1)

        print("Dist: %2.10fm   Gaze pos: (%10.10s,%10.10s)   Cursor pos: (%2.5f,%2.5f)" % (userDistanceFromCam,str(gaze.horizontal_ratio()),str(gaze.vertical_ratio()),currentMousePos[0],currentMousePos[1]))
        # Saving video data
        writer.write(frame)

    cv2.imshow("Eye tracker", frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

    if cv2.waitKey(33) == ord('r'):
        recordData = not recordData

writer.release()
output.close()
