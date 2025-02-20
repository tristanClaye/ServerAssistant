from flask import Flask, request, jsonify
import subprocess
import shlex

app = Flask(__name__)

def extract_order_from_transcript(transcript):
    """Uses AI (Mistral) to extract restaurant orders."""
    if not transcript.strip():
        return "⚠️ No valid transcript provided."

    prompt = f"""
    You are an AI assistant that formats restaurant orders in shorthand.

    **Rules:**
    - Extract ordered items ONLY.
    - DO NOT add extra words.
    - Format wine sizes properly (e.g., "9oz house white").
    - Special instructions: "7oz sirloin - medium - Special instruction: no salt".

    Example Input:
    "Can I get a 9-ounce house white, a sirloin cooked medium, and a side of fries?"
    
    Expected Output:
    Seat 1:
    9oz hse whte
    7oz sirloin - medium
    fries

    Now extract the order from:
    "{transcript}"
    """

    command = f'ollama run mistral {shlex.quote(prompt)}'
    result = subprocess.run(command, shell=True, capture_output=True, text=True)

    if result.returncode != 0:
        return f"Error: {result.stderr.strip()}"

    return result.stdout.strip()

@app.route("/process_order", methods=["POST"])
def process_order():
    """Receives transcript & returns AI-processed order."""
    data = request.get_json()

    if not data or "transcript" not in data:
        return jsonify({"error": "No transcript provided"}), 400

    transcript = data["transcript"].strip()
    if not transcript:
        return jsonify({"error": "Transcript is empty"}), 400

    formatted_order = extract_order_from_transcript(transcript)

    return jsonify({"order": formatted_order})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
