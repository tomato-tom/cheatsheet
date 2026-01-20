cat <<EOF > index.html
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cheat Sheets</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown-light.min.css">
    <style>
        body { background:#f6f8fa; padding:20px; display:flex; justify-content:center; }
        .markdown-body { box-sizing:border-box; min-width:200px; max-width:980px; margin:0 auto; padding:45px; background:white; border:1px solid #d0d7de; border-radius:6px; }
        #back-btn { display:none; margin-bottom:20px; cursor:pointer; color:#0969da; font-weight:bold; border:none; background:none; }
    </style>
</head>
<body>
    <article class="markdown-body">
        <button id="back-btn" onclick="location.reload()">← TOP</button>
        <div id="content">
            <h1>Cheat Sheets</h1>
            <ul>
$(ls *.md | grep -v "README.md" | sed 's/\(.*\)\.md/                <li><a href="\1.md">\1<\/a><\/li>/')
            </ul>
        </div>
    </article>
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <script>
        document.querySelectorAll('a').forEach(link => {
            if (link.getAttribute('href').endsWith('.md')) {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    fetch(this.getAttribute('href')).then(res => res.text()).then(md => {
                        document.getElementById('content').innerHTML = marked.parse(md);
                        document.getElementById('back-btn').style.display = 'block';
                        window.scrollTo(0,0);
                    });
                });
            }
        });
    </script>
</body>
</html>
EOF
