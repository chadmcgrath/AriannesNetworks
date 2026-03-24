"""
Build a mapping from IPIP item codes to question text.
Fetches the IPIP alphabetical item list and matches our 60 Neuroticism item codes.
"""

import requests
import re
import csv
import os
from html.parser import HTMLParser

IPIP_FACETS = {
    'N1_Anxiety':       ['e141_R', 'e150_R', 'h1046_R', 'h1157', 'h2000_R', 'h968', 'h999', 'x107', 'x120', 'x138_R'],
    'N2_Anger':         ['e120_R', 'h754', 'h755', 'h761', 'x191_R', 'x23_R', 'x231_R', 'x265_R', 'x84', 'x95'],
    'N3_Depression':    ['e92', 'h640', 'h646', 'h737_R', 'h947', 'x129_R', 'x15', 'x156_R', 'x205', 'x74'],
    'N4_SelfConscious': ['h1197_R', 'h1205', 'h592', 'h655', 'h656', 'h905', 'h991', 'x197_R', 'x209_R', 'x242_R'],
    'N5_Immoderation':  ['e24', 'e30_R', 'e57', 'h2029', 'x133', 'x145', 'x181_R', 'x216_R', 'x251_R', 'x274_R'],
    'N6_Vulnerability': ['e64_R', 'h1281_R', 'h44_R', 'h470_R', 'h901', 'h948', 'h950', 'h954', 'h959', 'x79_R'],
}

all_codes = set()
for items in IPIP_FACETS.values():
    for item in items:
        base = item.replace('_R', '')
        all_codes.add(base.upper())

print(f"Looking for {len(all_codes)} unique item codes")

url = "https://ipip.ori.org/AlphabeticalItemList.htm"
print(f"Fetching {url}...")
resp = requests.get(url, timeout=60)
resp.raise_for_status()
html = resp.text
print(f"Fetched {len(html)} characters")

# The page structure is a table where each row has two cells:
# cell 1 = item text, cell 2 = item code(s)
class IPIPParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.in_td = False
        self.cells = []
        self.current_cell = ""
        self.row_cells = []
        
    def handle_starttag(self, tag, attrs):
        if tag == "td":
            self.in_td = True
            self.current_cell = ""
        elif tag == "tr":
            self.row_cells = []
            
    def handle_endtag(self, tag):
        if tag == "td":
            self.in_td = False
            self.row_cells.append(self.current_cell.strip())
        elif tag == "tr":
            if len(self.row_cells) >= 2:
                self.cells.append((self.row_cells[0], self.row_cells[1]))
                
    def handle_data(self, data):
        if self.in_td:
            self.current_cell += data

parser = IPIPParser()
parser.feed(html)

print(f"Parsed {len(parser.cells)} table rows")

code_to_text = {}
for text, codes in parser.cells:
    text = text.strip()
    codes_str = codes.strip()
    found_codes = re.findall(r'[A-Z]\d+', codes_str)
    for code in found_codes:
        if code in all_codes:
            code_to_text[code] = text

print(f"Matched {len(code_to_text)} of {len(all_codes)} codes")

# Print results
print("\n" + "=" * 70)
print("ITEM CODE TO TEXT MAPPING")
print("=" * 70)

# Build final mapping with facet info
rows = []
for facet_name, items in IPIP_FACETS.items():
    for item in items:
        base = item.replace('_R', '').upper()
        is_reversed = '_R' in item
        text = code_to_text.get(base, "UNMATCHED")
        keying = "negative (reversed)" if is_reversed else "positive"
        print(f"  {item:12s} | {facet_name:20s} | {keying:22s} | {text}")
        rows.append({
            'item_code': item,
            'base_code': base,
            'facet': facet_name,
            'keying': keying,
            'item_text': text,
        })

# Save mapping
os.makedirs("results", exist_ok=True)
with open("results/item_code_to_text.csv", "w", newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=['item_code', 'base_code', 'facet', 'keying', 'item_text'])
    writer.writeheader()
    writer.writerows(rows)

unmatched = [r for r in rows if r['item_text'] == 'UNMATCHED']
print(f"\nUnmatched: {len(unmatched)}")
for r in unmatched:
    print(f"  {r['item_code']} ({r['facet']})")

print(f"\nSaved to results/item_code_to_text.csv")
