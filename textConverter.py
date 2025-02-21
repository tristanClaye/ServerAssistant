from flask import Flask, request, jsonify
import openai
import os

app = Flask(__name__)

# ✅ Set your OpenAI API Key
openai.api_key = os.getenv("OPENAI_API_KEY")  # Set this in Railway's environment variables

def extract_order_from_transcript(transcript):
    """Uses OpenAI GPT-4 to extract restaurant orders in shorthand format."""
    prompt = f"""
    You are an AI assistant that helps restaurant servers take orders.
    Your task is to extract all ordered items and format them in shorthand for a POS system.

    **RULES:**
    - DO NOT use extra words, just list the orders in shorthand format.
    - Wines must specify size (if given). Example: "9-ounce house white" → "9oz hse whte".
    - Return orders by seat number in order given, for example: "I'd like a steak cooked medium. Hi, I'd like the chicken bryan and a 6oz house white" → "Seat 1: 7oz sirloin (med) - Seat 2: chx bryan 6oz hse whte"
    - Special instructions should be written in this exact format:
      - "7oz sirloin - medium - Special instruction: no salt"
    - If a customer mentions **not** wanting an item (e.g., "No chicken soup"), ignore that item.
    - Ignore small talk and questions like "What drinks do you have?"

    **Example Input:**
    "Can I get a 9-ounce house white, a sirloin cooked medium, and a side of fries? And I'll do a chicken bryan with a side of broccoli. Yup, that's it, oh and no tomatoes on the chicken bryan."

    **Expected Output:**
    Seat 1:
    9oz hse whte
    7oz sirloin - medium
    fries
    Seat 2:
    chx bryan - Special instruction: no tomatoes
    brocc

    Now, extract the order from this transcript:
    "{transcript}"

    Return only the shorthand order output.
    """

    try:
        response = openai.ChatCompletion.create(
            model="gpt-4-turbo",
            messages=[{"role": "system", "content": prompt}],
            temperature=0.5
        )
        return response["choices"][0]["message"]["content"].strip()
    except Exception as e:
        return f"Error: {str(e)}"

@app.route("/process_order", methods=["POST"])
def process_order():
    """Receives transcript from Swift and returns AI-generated order shorthand."""
    data = request.get_json()

    if not data or "transcript" not in data:
        return jsonify({"error": "No transcript provided"}), 400

    transcript = data["transcript"].strip()
    if not transcript:
        return jsonify({"error": "Transcript is empty"}), 400

    formatted_order = extract_order_from_transcript(transcript)

    # ✅ Ensure it always returns a valid JSON response
    if not formatted_order.strip():
        return jsonify({"error": "No valid order detected"}), 200

    return jsonify({"order": formatted_order})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)