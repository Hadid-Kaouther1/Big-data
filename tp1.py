import requests
from bs4 import BeautifulSoup
import pandas as pd
import time

def fetch_html(url):
    """تحميل الصفحة وإرجاع محتواها"""
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.text
    else:
        print(f" فشل تحميل الصفحة: {url}")
        return None

def extract_quotes(html):
    """استخراج الاقتباسات والمؤلفين"""
    soup = BeautifulSoup(html, "html.parser")
    quotes_data = []

    # كل اقتباس في Goodreads داخل <div class="quoteText">
    quote_blocks = soup.find_all("div", class_="quoteText")
    for block in quote_blocks:
        text = block.get_text(strip=True, separator=" ").split("―")[0].strip()
        author = block.find("span", class_="authorOrTitle")
        if author:
            author_name = author.get_text(strip=True)
        else:
            author_name = "غير معروف"
        quotes_data.append({
            "Quote": text,
            "Author": author_name
        })
    return quotes_data

def main():
    all_quotes = []
    page = 1

    while len(all_quotes) < 1000:
        url = f"https://www.goodreads.com/quotes?page={page}"
        print(f"جاري تحميل الصفحة {page}... ({url})")

        html = fetch_html(url)
        if not html:
            break

        quotes = extract_quotes(html)
        if not quotes:
            print(f" لا توجد اقتباسات في الصفحة {page} (انتهت الصفحات)")
            break

        all_quotes.extend(quotes)
        print(f" تم استخراج {len(quotes)} اقتباس من الصفحة {page}")
        page += 1
        time.sleep(1)

    print(f" المجموع الكلي: {len(all_quotes)} اقتباساً")

    # حفظ النتائج في CSV
    df = pd.DataFrame(all_quotes)
    df.to_csv("quotes.csv", index=False, encoding="utf-8-sig")
    print(" تم حفظ النتائج في quotes.csv")

if __name__ == "__main__":
    main()
