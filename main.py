import cv2
from pynput.mouse import Button, Controller
from gaze_tracking import GazeTracking

gaze = GazeTracking()
webcam = cv2.VideoCapture(0)
mouse = Controller()
output = open("output.txt", "w")
recordData = False

while True:
    # We get a new frame from the webcam
    _, frame = webcam.read()

    # We send this frame to GazeTracking to analyze it
    gaze.refresh(frame)

    frame = gaze.annotated_frame()
    text = ""

    cv2.putText(frame, text, (90, 60), cv2.FONT_HERSHEY_DUPLEX, 1.6, (147, 58, 31), 2)

    currentMousePos = mouse.position

    if gaze.horizontal_ratio() is not None and gaze.vertical_ratio() is not None:
        cv2.arrowedLine(frame, (100, 100), (int(gaze.horizontal_ratio()*200), int(-50+gaze.vertical_ratio()*200)), (0, 255, 0), 9)
        print(int(gaze.vertical_ratio()))

    if recordData:
        output.write(str(gaze.horizontal_ratio()) + "," + str(gaze.vertical_ratio()) + "," + str(currentMousePos[0]) + "," + str(currentMousePos[1]) + "\n")
        cv2.circle(frame, (1200, 50), 30, (0, 0, 255), -1)

    cv2.imshow("Cursor Position Calculator", frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

    if cv2.waitKey(33) == ord('r'):
        recordData = not recordData

output.close()
