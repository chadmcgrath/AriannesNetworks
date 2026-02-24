#!/usr/bin/env python3
"""Search PDF for 2.5 and centralization mentions"""

try:
    from pdfminer.high_level import extract_text
    import re
    
    pdf_path = 'docs/Herrera-Bennett & Rhemtulla [2021, preprint] - Network replicability & generalizability_Supplementary_R1.pdf'
    
    print("Extracting text from PDF...")
    text = extract_text(pdf_path)
    
    # Search for 2.5 or centralization
    pattern = r'2\.5|2.5|centralization|centraliz'
    matches = list(re.finditer(pattern, text, re.IGNORECASE))
    
    print(f"\nFound {len(matches)} matches\n")
    
    # Show first 10 matches with context
    for i, match in enumerate(matches[:10]):
        start = max(0, match.start() - 150)
        end = min(len(text), match.end() + 150)
        context = text[start:end]
        
        # Estimate page number (rough estimate: ~3000 chars per page)
        page_estimate = start // 3000 + 1
        
        print(f"Match {i+1} (around page {page_estimate}):")
        print(f"  Found: '{match.group()}'")
        print(f"  Context: ...{context}...")
        print()
        
except ImportError:
    print("pdfminer not available, trying PyPDF2...")
    try:
        import PyPDF2
        
        pdf_path = 'docs/Herrera-Bennett & Rhemtulla [2021, preprint] - Network replicability & generalizability_Supplementary_R1.pdf'
        pdf = open(pdf_path, 'rb')
        reader = PyPDF2.PdfReader(pdf)
        
        print(f"PDF has {len(reader.pages)} pages\n")
        
        # Search all pages for centralization, 2.5, and related terms
        print("Searching all pages...\n")
        
        for page_num, page in enumerate(reader.pages, 1):
            page_text = page.extract_text()
            page_lower = page_text.lower()
            
            # Check for various terms
            has_centralization = 'centralization' in page_lower or 'centraliz' in page_lower
            has_25 = '2.5' in page_text
            has_times = 'times' in page_lower
            has_item = 'item' in page_lower and ('aggregation' in page_lower or 'per facet' in page_lower)
            has_sample_size = 'sample size' in page_lower
            
            if has_centralization:
                print(f"\n{'='*70}")
                print(f"Page {page_num} - Contains 'centralization'")
                print(f"{'='*70}")
                print(page_text[:1500])
                if len(page_text) > 1500:
                    print("\n... [truncated] ...")
                print()
            elif has_25 and (has_item or has_sample_size):
                print(f"\n{'='*70}")
                print(f"Page {page_num} - Contains '2.5' with item/sample size context")
                print(f"{'='*70}")
                print(page_text[:1500])
                if len(page_text) > 1500:
                    print("\n... [truncated] ...")
                print()
                        
    except Exception as e:
        print(f"Error: {e}")
except Exception as e:
    print(f"Error: {e}")

