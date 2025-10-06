import requests
from bs4 import BeautifulSoup

# حاول استيراد pandas لو موجود، وإلا نكمل بدون حفظ CSV
try:
    import pandas as pd
    PANDAS_AVAILABLE = True
except ImportError:
    PANDAS_AVAILABLE = False

def fetch_html(url, timeout=10):
    """يحمل HTML من العنوان ويعيد النص و رمز الحالة"""
    headers = {
        "User-Agent": "Mozilla/5.0 (compatible; Bot/0.1; +https://example.com/bot)"
    }
    resp = requests.get(url, headers=headers, timeout=timeout)
    resp.raise_for_status()  # يرفع استثناء لو كان هناك خطأ
    return resp.text

def extract_quotes_from_soup(soup):
    """
    يبحث عن اقتباسات في الصفحة. يدعم شكل موقع quotes.toscrape.com
    ويجرب بدائل: عناصر <blockquote> أو عناصر لها class يحتوي 'quote' أو <p class="text">.
    يعيد قائمة من القواميس: {'text':..., 'author':..., 'tags': [...]}
    """
    results = []

    # حالة شائعة: site "quotes.toscrape.com"
    quote_divs = soup.find_all("div", class_="quote")
    if quote_divs:
        for q in quote_divs:
            text_tag = q.find("span", class_="text")
            author_tag = q.find("small", class_="author")
            tags = [t.get_text(strip=True) for t in q.find_all("a", class_="tag")]
            results.append({
                "text": text_tag.get_text(strip=True) if text_tag else "",
                "author": author_tag.get_text(strip=True) if author_tag else "",
                "tags": ", ".join(tags)
            })
        return results

    # بديل: عناصر blockquote
    blockquotes = soup.find_all("blockquote")
    if blockquotes:
        for b in blockquotes:
            # نص الاقتباس (نأخذ النص الداخلي)
            text = b.get_text(strip=True)
            results.append({"text": text, "author": "", "tags": ""})
        return results

    # بديل عام: ابحث عن <p class="text"> أو عن كل <p>
    p_texts = soup.find_all("p", class_="text")
    if p_texts:
        for p in p_texts:
            results.append({"text": p.get_text(strip=True), "author": "", "tags": ""})
        return results

    # آخر حل: اجمع كل <p> صغيرة (تحفظ بعض الاقتباسات)
    p_tags = soup.find_all("p")
    for p in p_tags:
        txt = p.get_text(strip=True)
        if len(txt) > 30:  # فلترة نصوص قصيرة جدًا
            results.append({"text": txt, "author": "", "tags": ""})

    return results

def main():
    # غَيِّر هذا الرابط وفق المطلوب: المثال الرسمي للاقتباسات:
    url = "https://quotes.toscrape.com/"  # أو "https://books.toscrape.com/" لو أردت صفحة الكتب

    print(f"Fetching: {url}")
    html = fetch_html(url)

    # 1) عرض HTML (يمكن تعديل الطباعة لعرض جزء فقط)
    print("\n--- بداية HTML (أول 1000 حرف) ---\n")
    print(html[:1000])   # بدل 1000 لتطبع أكثر أو اطبع html كله بحذر
    print("\n--- نهاية جزء HTML ---\n")

    # 2) استخراج الاقتباسات باستخدام BeautifulSoup
    soup = BeautifulSoup(html, "html.parser")
    quotes = extract_quotes_from_soup(soup)
    print(f"اكتشفت {len(quotes)} اقتباس(ات).")

    # عرض أول 10 اقتباسات (أو كلهم)
    for i, q in enumerate(quotes[:10], start=1):
        print(f"{i}. \"{q['text']}\" — {q.get('author','')}")
        if q.get("tags"):
            print(f"   tags: {q['tags']}")

    # 3) حفظ النتائج في CSV باستخدام pandas (إن وجد)
    if PANDAS_AVAILABLE:
        df = pd.DataFrame(quotes)
        csv_filename = "quotes.csv"
        df.to_csv(csv_filename, index=False, encoding="utf-8-sig")
        print(f"تم حفظ النتائج إلى {csv_filename}")
    else:
        print("pandas غير مثبت، تم تخطي حفظ CSV. للتثبيت: pip install pandas")

if __name__ == "__main__":
    main()