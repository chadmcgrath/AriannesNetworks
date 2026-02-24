#!/usr/bin/env python3
"""Search main paper PDF for 2.5x finding and centralization"""

import PyPDF2

pdf_path = 'docs/Herrera-Bennett & Rhemtulla_ManuscriptFull_MBR_R2.pdf'
pdf = open(pdf_path, 'rb')
reader = PyPDF2.PdfReader(pdf)

print(f"PDF has {len(reader.pages)} pages\n")
print("="*70)
print("Searching for pages with 2.5x finding and centralization...")
print("="*70)

for page_num, page in enumerate(reader.pages, 1):
    page_text = page.extract_text()
    page_lower = page_text.lower()
    
    # Check for key terms
    has_25 = '2.5' in page_text or '2.5x' in page_lower
    has_centralization = 'centralization' in page_lower or 'centraliz' in page_lower
    has_times = 'times' in page_lower and ('sample' in page_lower or 'size' in page_lower)
    has_item_agg = 'item' in page_lower and ('aggregation' in page_lower or 'per facet' in page_lower)
    
    # If page has centralization AND (2.5 OR times), it's likely the finding
    if has_centralization and (has_25 or has_times):
        print(f"\n{'='*70}")
        print(f"FOUND IT! Page {page_num}")
        print(f"{'='*70}")
        print(page_text)
        print(f"\n{'='*70}\n")
    elif has_centralization:
        print(f"\nPage {page_num} mentions centralization:")
        # Show context around centralization
        lines = page_text.split('\n')
        for i, line in enumerate(lines):
            if 'centralization' in line.lower():
                start = max(0, i - 5)
                end = min(len(lines), i + 6)
                context = '\n'.join(lines[start:end])
                print(f"  {context[:600]}...")
                print()
                break

pdf.close()

