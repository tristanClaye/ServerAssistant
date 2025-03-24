from PyPDF2 import PdfReader

# Replace with file path of the menu PDF
pdf_path = "Carrabba_Nutrition.pdf"

reader = PdfReader(pdf_path)

menu_text = ""
for page in reader.pages:
    menu_text += page.extract_text() + "\n"

# Save to a .txt file for OpenAI prompt use
with open("carrabbas_menu_transcript.txt", "w") as f:
    f.write(menu_text)

print("✅ Menu extracted and saved!")