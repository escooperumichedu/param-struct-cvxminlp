using Tesseract, Images, FileIO

# Load the image
image_path = "C:\\Users\\goson\\Desktop\\git\\param-struct-cvxminlp\\image-extractor\\image-tables\\tab1.PNG"  # Change this to your image file path
img = load(image_path)

# Perform OCR using Tesseract
extracted_text = Tesseract.ocr(image_path)  # Pass the image path directly to `ocr`

# Print extracted text
println("Extracted text:")
println(extracted_text)

# Process the extracted text by splitting it into lines
lines = split(extracted_text, '\n')

# Join the lines using a tab character (TSV format)
tsv_text = join(lines, '\t')

# Save the text in a TSV file for Excel
output_file = "output.tsv"
open(output_file, "w") do io
    write(io, tsv_text)
end