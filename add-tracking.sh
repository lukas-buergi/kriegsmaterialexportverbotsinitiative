#!/bin/bash
set -euo pipefail # be careful

function add-msg {
  echo "$1"
  orig1='<\/head>'

  repl1=$(cat <<EOF
<!-- Matomo -->
<script type="text/javascript">
  var _paq = window._paq || [];
  /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
  _paq.push(['trackPageView']);
  _paq.push(['enableLinkTracking']);
  (function() {
    var u="//web-statistik.gsoa.ch/matomo/";
    _paq.push(['setTrackerUrl', u+'matomo.php']);
    _paq.push(['setSiteId', '3']);
    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
    g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'matomo.js'; s.parentNode.insertBefore(g,s);
  })();
</script>
<noscript><p><img src="//web-statistik.gsoa.ch/matomo/matomo.php?idsite=3&amp;rec=1" style="border:0;" alt="" /></p></noscript>
<!-- End Matomo Code -->
</head>
EOF
)

  repl1="$(echo "$repl1" | sed -e 's/[\/&]/\\&/g' | tr '\n' '\r')"

  new=$(cat "$1" | tr '\n' '\r' | sed -e "s/$orig1/$repl1/" | tr '\r' '\n')
  echo "$new" > "$1"
}

export -f add-msg

#add-msg index.html
find . -type f -name "*.html" -exec bash -c 'add-msg "$1"' - {} \;

