from flask import Flask, request, jsonify
import subprocess
import shlex

app = Flask(__name__)

def extract_order_from_transcript(transcript):
    """Uses OpenAI to extract restaurant orders."""
    prompt = f"""
    You are an AI assistant that helps restaurant servers take orders.
    Your task is to extract all ordered items and format them in shorthand for a POS system.

    - Extract and format orders clearly.
    - Ignore small talk or questions.
    - Use shorthand format for menu items.

    Transcript:
    "{transcript}"

    Return only the shorthand order output.
    """

    command = f'ollama run mistral {shlex.quote(prompt)}'
    result = subprocess.run(command, shell=True, capture_output=True, text=True)

    if result.returncode != 0:
        return f"Error: {result.stderr.strip()}"

    return result.stdout.strip()

@app.route("/process_order", methods=["POST"])
def process_order():
    """Receives transcript and returns formatted order."""
    data = request.get_json()

    if not data or "transcript" not in data:
        return jsonify({"error": "No transcript provided"}), 400

    transcript = data["transcript"].strip()
    if not transcript:
        return jsonify({"error": "Transcript is empty"}), 400

    formatted_order = extract_order_from_transcript(transcript)

    return jsonify({"order": formatted_order}) if formatted_order.strip() else jsonify({"error": "No valid order detected"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)