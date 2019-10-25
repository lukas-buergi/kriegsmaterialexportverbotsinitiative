#!/bin/bash
set -euo pipefail # be careful

function add-msg {
  echo "$1"
  orig1='<!-- Layout -->'

  repl1='<div class="disclaimer">
  Diese Seite wurde archiviert - besuchen sie
  <a href="https://gsoa.ch">gsoa.ch</a> und
  <a href="https://kriegsmaterial.ch">kriegsmaterial.ch</a>
  für aktuelle Informationen.
</div>
<!-- Layout -->'

  repl1="$(echo "$repl1" | sed -e 's/[\/&]/\\&/g' | tr '\n' '\r')"

  orig2='<\/head>'
  repl2='</head>
  <style>
    .disclaimer {
      background-color: #EEEEEE;
      color: #440000;
      text-align: center;
      font-size: 1.2rem;
      line-height: 4em;
    }
  </style>'
  repl2="$(echo "$repl2" | sed -e 's/[\/&]/\\&/g' | tr '\n' '\r')"

  new=$(cat "$1" | tr '\n' '\r' | sed -e "s/$orig1/$repl1/" -e "s/$orig2/$repl2/" | tr '\r' '\n')
  echo "$new" > "$1"
}

export -f add-msg

#add-msg index.html
find . -type f -name "*.html" -exec bash -c 'add-msg "$1"' - {} \;

