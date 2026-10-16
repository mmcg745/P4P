import re, glob, sys, os
os.chdir(sys.argv[1])
B = "\\"
files = ['mainDocument.tex'] + sorted(glob.glob('sections/*.tex'))
labels = set(); refs = []; cites = set()
for f in files:
    s = open(f, encoding='utf-8').read()
    t = re.sub(r'(?<!\\)%.*', '', s)
    t2 = t.replace(B + '{', '').replace(B + '}', '')
    if t2.count('{') != t2.count('}'):
        print('BRACE', f, t2.count('{'), t2.count('}'))
    st = []
    for m in re.finditer(r'\\(begin|end)\{([^}]*)\}', t):
        if m.group(1) == 'begin':
            st.append(m.group(2))
        else:
            if not st or st[-1] != m.group(2):
                print('ENV', f, m.group(2), st[-1:])
            else:
                st.pop()
    if st:
        print('UNCLOSED', f, st)
    labels |= set(re.findall(r'\\label\{([^}]*)\}', t))
    refs += re.findall(r'\\(?:eq)?ref\{([^}]*)\}', t)
    for c in re.findall(r'\\(?:text|paren)?cite\{([^}]*)\}', t):
        cites |= {x.strip() for x in c.split(',')}
    if t2.replace(B + '$', '').count('$') % 2:
        print('DOLLAR', f)
    for m in re.findall(r'[^\x00-\x7f]', s):
        print('nonascii', f, repr(m))
print('undefined refs', sorted(set(refs) - labels))
bib = set(re.findall(r'@\w+\{([^,]+),', open('RefDatabase.bib', encoding='utf-8').read()))
print('missing cites', sorted(cites - bib))
print('uncited', sorted(bib - cites))
