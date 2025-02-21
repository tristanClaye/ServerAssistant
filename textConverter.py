from flask import Flask, request, jsonify #import Flask
import openai
import os

app = Flask(__name__) #initialize the Flask app
openai.api_key = os.getenv("OPENAI_API_KEY")  # Load API key from environment variables

def extract_order_from_transcript(transcript):
    """Uses OpenAI API to extract restaurant orders."""
    
    prompt = f"""
    You are an AI assistant that helps restaurant servers take orders.
    Your task is to extract all ordered items and format them in shorthand for a POS system.

    **Rules:**
    - DO NOT use extra words, just list the orders in shorthand format.
    - Wines must specify size (if given). Example: "9-ounce house white" → "9oz hse whte".
    - Orders must be grouped by seat number. Example:
      "I'd like a steak medium. Hi, I'd like chicken bryan and a 6oz house white" →
      "Seat 1: 7oz sirloin (med) - Seat 2: chx bryan, 6oz hse whte"
    - Special instructions should be written as:
      - "7oz sirloin - medium - Special instruction: no salt"
    - Ignore small talk and questions like "What drinks do you have?"

    Now, extract the order from this transcript:
    "{transcript}"

    Return only the shorthand order output.
    """

    try:
        response = openai.ChatCompletion.create(
            model="gpt-4",  # Or "gpt-3.5-turbo" if cost is a concern
            messages=[{"role": "system", "content": prompt}],
            max_tokens=150,
        )

        return response["choices"][0]["message"]["content"].strip()

    except Exception as e:
        return f"Error: {str(e)}"

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