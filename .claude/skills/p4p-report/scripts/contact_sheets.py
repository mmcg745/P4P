"""Render a PDF into contact sheets (24 pages each) for a quick visual check."""
import sys, os
import pypdfium2 as pdfium
from PIL import Image

pdf_path, out_dir = sys.argv[1], sys.argv[2]
os.makedirs(out_dir, exist_ok=True)
pdf = pdfium.PdfDocument(pdf_path)
ims = [pdf[i].render(scale=45 / 72).to_pil() for i in range(len(pdf))]
w, h = ims[0].size
cols = 8
for k in range(0, len(ims), 24):
    chunk = ims[k:k + 24]
    rows = (len(chunk) + cols - 1) // cols
    sheet = Image.new('RGB', (cols * w, rows * h), 'white')
    for i, im in enumerate(chunk):
        sheet.paste(im, ((i % cols) * w, (i // cols) * h))
    sheet.save(os.path.join(out_dir, f'sheet{k // 24}.png'))
print(len(ims), 'pages')
