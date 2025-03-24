from flask import Flask, request, jsonify #import Flask
import openai
import os

app = Flask(__name__) #initialize the Flask app
openai.api_key = os.getenv("OPENAI_API_KEY")  # Load API key from environment variables

with open("carrabbas_menu_transcript.txt", "r", encoding="utf-8") as file:
    full_menu = file.read()

def extract_order_from_transcript(transcript):
    """Uses OpenAI API to convert restaurant orders."""
    
    prompt = f"""
    You are an AI assistant that helps restaurant servers take orders.
    Your task is to extract all ordered items and output them in legible shorthand.

    **Rules:**
    - DO NOT use extra words, just list the orders in shorthand format.
    - Wines must specify size (if given). Example: "9-ounce house white" → "9oz hse white".
    - Orders must be grouped by seat number. Example:
      "I'd like a steak medium. Hi, I'd like chicken bryan and a 6oz house white" →
      "Seat 1: 7oz sirloin (med) - Seat 2: chx bryan, 6oz hse white"
    - Special instructions should be written as:
      - "7oz sirloin - medium - Special instruction: no salt"
    - Ignore small talk and questions like "What drinks do you have?"
    - Heres the menu for reference (you can ingore the nutrition info, ALSO if an order contains an item not on the menu, start the output with !?!): {full_menu}
    - If an order sounds similar to something on the menu, then output that menu item, the voice transcripter may be slightly inacurrate.

    Now, extract the order from this transcript:
    "{transcript}"

    Return only the shorthand order output.
    """

    try:
        response = openai.chat.completions.create(
            model="gpt-4o",
            messages=[{"role": "system", "content": prompt}],
            max_tokens=150,
        )   

        return response.choices[0].message.content.strip()

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
    app.run(host="0.0.0.0", port=8080)  # Make sure it's 8080, not 5000