from flask import Flask, Response, send_file
from picamera2 import Picamera2
from picamera2.encoders import JpegEncoder
from picamera2.outputs import FileOutput
import io
import logging
from threading import Condition

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('PiStream')

app = Flask(__name__)
picam2 = None
output = None

class StreamingOutput(io.BufferedIOBase):
    def __init__(self):
        self.frame = None
        self.condition = Condition()

    def write(self, buf):
        with self.condition:
            self.frame = buf
            self.condition.notify_all()

def init_camera():
    global picam2, output
    picam2 = Picamera2()

    # Configure camera for continuous video streaming at 640x480
    video_config = picam2.create_video_configuration(
        main={"size": (640, 480)},
        controls={"FrameDurationLimits": (16666, 16666)}  # ~60fps
    )
    picam2.configure(video_config)
    output = StreamingOutput()
    picam2.start_recording(JpegEncoder(), FileOutput(output))
    logger.info("Camera initialized for continuous streaming")

def generate_frames():
    try:
        while True:
            with output.condition:
                output.condition.wait()
                frame = output.frame
            yield (b'--frame\r\n'
                  b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')
    except Exception as e:
        logger.error(f"Frame generation error: {str(e)}")

@app.route('/')
def index():
    """Homepage showing live video stream."""
    return """
    <html>
        <head>
            <title>Raspberry Pi Camera Stream</title>
        </head>
        <body>
            <h1>Live Stream from Raspberry Pi Camera</h1>
            <img src="/video_feed" width="640" height="480" />
        </body>
    </html>
    """

@app.route('/video_feed')
def video_feed():
    """Continuous video feed endpoint."""
    return Response(generate_frames(),
                   mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/capture', methods=['GET'])
def capture_photo():
    """Capture a still image without interrupting the stream."""
    try:
        # Create a buffer for the captured image
        buffer = io.BytesIO()
        
        # Capture image while stream continues
        picam2.capture_file(buffer, format='jpeg')
        buffer.seek(0)
        
        logger.info("Photo captured successfully")
        return send_file(
            buffer,
            mimetype='image/jpeg',
            download_name='capture.jpg'
        )

    except Exception as e:
        logger.error(f"Capture error: {str(e)}")
        return Response(str(e), status=500)

if __name__ == '__main__':
    try:
        init_camera()
        app.run(host='0.0.0.0', port=5000, threaded=True)
    except Exception as e:
        logger.error(f"Server error: {str(e)}")
    finally:
        if picam2:
            picam2.stop_recording()
            logger.info("Camera stopped")
