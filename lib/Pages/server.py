from flask import Flask, request, jsonify
import requests
from PIL import Image
from io import BytesIO
import cv2
import numpy as np
import os
import time
from paddleocr import PaddleOCR

app = Flask(__name__)

# Initialize PaddleOCR
reader = PaddleOCR(use_angle_cls=True, lang='en')

# Create folders if not exist
os.makedirs("captchas", exist_ok=True)
os.makedirs("failed", exist_ok=True)

# Image preprocessing
def preprocess_image(pil_img):
    img = np.array(pil_img.convert('L'))  # Grayscale
    img = cv2.bilateralFilter(img, 11, 17, 17)  # Denoise
    img = cv2.equalizeHist(img)  # Enhance contrast
    img = cv2.adaptiveThreshold(img, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, 
                                cv2.THRESH_BINARY_INV, 11, 2)  # Adaptive threshold
    kernel = np.ones((2, 2), np.uint8)
    img = cv2.morphologyEx(img, cv2.MORPH_OPEN, kernel)  # Remove small dots
    img = cv2.dilate(img, kernel, iterations=1)  # Dilate characters
    return img

# Download and solve captcha
def fetch_and_read_captcha(index, max_attempts=5):
    url = "https://ois.beykoz.edu.tr/auth/captcha"
    headers = {"User-Agent": "Mozilla/5.0"}

    session = requests.Session()
    for attempt in range(1, max_attempts + 1):
        try:
            response = session.get(url, headers=headers, timeout=10)
            if response.status_code != 200:
                print(f"❌ [{index}] Status code: {response.status_code}")
                return None

            pil_img = Image.open(BytesIO(response.content))

            # Save original image
            original_path = f"captchas/original_{index}.png"
            try:
                pil_img.save(original_path)
            except Exception as e:
                print(f"❌ Error saving original image [{index}]: {e}")

            # Preprocess image
            processed_img = preprocess_image(pil_img)

            # Save processed image
            processed_path = f"captchas/processed_{index}.png"
            saved = cv2.imwrite(processed_path, processed_img)
            if not saved:
                print(f"⚠️ Processed image not saved [{index}]!")

            # OCR with PaddleOCR
            try:
                result = reader.ocr(processed_path)
                print(f"🔎 CAPTCHA [{index}] Try {attempt} OCR raw result: {result}")
            except Exception as e:
                print(f"❌ CAPTCHA [{index}] Try {attempt} PaddleOCR error: {e}")
                continue

            # Extract text based on actual result structure
            text = None
            if isinstance(result, list) and len(result) > 0:
                if isinstance(result[0], list) and len(result[0]) > 1 and isinstance(result[0][1], tuple):
                    text_candidate = result[0][1][0]
                    if isinstance(text_candidate, str) and text_candidate.strip() != "":
                        text = text_candidate.replace(" ", "").strip()
                elif (
                    isinstance(result[0], list)
                    and any(isinstance(item, tuple) and len(item) > 0 and isinstance(item[0], str) for item in result[0])
                ):
                    for item in result[0]:
                        if isinstance(item, tuple) and len(item) > 0 and isinstance(item[0], str) and item[0].strip() != "":
                            text = item[0].replace(" ", "").strip()
                            break

            if text:
                if len(text) == 4 and text.isalnum() and any(c.isupper() for c in text):
                    print(f"✅ CAPTCHA [{index}] Try {attempt}: {text}")
                    return text
                else:
                    print(f"⚠️ CAPTCHA [{index}] Try {attempt} rejected: '{text}'")
            else:
                print(f"❌ CAPTCHA [{index}] Try {attempt} OCR failed: {result}")

            time.sleep(2)  # Wait to avoid blocking

        except Exception as e:
            print(f"⚠️ Exception at [{index}] Try {attempt}: {e}")

    # Save failed image
    failed_path = f"failed/failed_{index}.png"
    try:
        pil_img.save(failed_path)
    except Exception as e:
        print(f"❌ Error saving failed image [{index}]: {e}")

    print(f"❌ CAPTCHA [{index}] Failed after {max_attempts} attempts. Saved to '{failed_path}'")
    return None

# Endpoint to solve captcha
@app.route('/solve_captcha', methods=['GET'])
def solve_captcha():
    index = int(request.args.get('index', 0))
    result = fetch_and_read_captcha(index)
    if result:
        return jsonify({'captcha': result})
    else:
        return jsonify({'error': 'Failed to solve CAPTCHA'}), 500

# Endpoint to solve captcha from base64 image
@app.route('/solve_captcha_base64', methods=['POST'])
def solve_captcha_base64():
    try:
        data = request.get_json()
        if not data or 'image_base64' not in data:
            return jsonify({'error': 'Missing image_base64 field'}), 400

        import base64
        image_data = base64.b64decode(data['image_base64'])
        pil_img = Image.open(BytesIO(image_data))

        processed_img = preprocess_image(pil_img)

        # Ensure processed_img is 3-channel (BGR) for PaddleOCR
        if len(processed_img.shape) == 2:
            processed_img = cv2.cvtColor(processed_img, cv2.COLOR_GRAY2BGR)

        result = reader.ocr(processed_img)
        print("DEBUG: OCR result structure:", repr(result))  # Debug print

        text = None
        if isinstance(result, list) and len(result) > 0:
            first = result[0]
            # Handle PaddleOCR dict output with 'rec_texts'
            if isinstance(first, dict) and 'rec_texts' in first:
                rec_texts = first['rec_texts']
                if isinstance(rec_texts, list) and len(rec_texts) > 0 and isinstance(rec_texts[0], str):
                    candidate = rec_texts[0].replace(" ", "").strip()
                    if candidate:
                        text = candidate
            # Fallback: try to extract text from legacy formats
            elif (
                isinstance(first, list)
                and len(first) > 1
                and isinstance(first[1], tuple)
                and len(first[1]) > 0
                and isinstance(first[1][0], str)
                and first[1][0].strip() != ""
            ):
                text_candidate = first[1][0]
                text = text_candidate.replace(" ", "").strip()
            elif (
                isinstance(first, list)
                and any(isinstance(item, tuple) and len(item) > 0 and isinstance(item[0], str) for item in first)
            ):
                for item in first:
                    if isinstance(item, tuple) and len(item) > 0 and isinstance(item[0], str) and item[0].strip() != "":
                        text = item[0].replace(" ", "").strip()
                        break

        if text:
            return jsonify({'captcha': text})
        else:
            print("DEBUG: No valid text extracted, OCR result:", repr(result))  # Debug print
            return jsonify({'error': 'Failed to solve CAPTCHA', 'ocr_result': str(result)}), 500
    except Exception as e:
        import traceback
        print("Exception in /solve_captcha_base64:", str(e))
        traceback.print_exc()
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
    #to run captcha solving service, use:
    #run python server.py
    # then run ngrok http 5000
    # then copy the URL and paste it in root page at 292 line
# Note: Ensure you have the required libraries installed:
# pip install Flask requests Pillow opencv-python numpy paddleocr
# Make sure to have PaddleOCR installed with the necessary models
# You can install PaddleOCR with:
# pip install paddleocr
# and download the models as per the PaddleOCR documentation
# Ensure you have the necessary environment for PaddleOCR, including PaddlePaddle
# You can install PaddlePaddle with:
# pip install paddlepaddle  

