#!/bin/zsh

alias -g NE='2>|/dev/null'
alias -g NO='&>|/dev/null'
alias -g EO='>|/dev/null'
alias -g G='| grep '
alias -g P='2>&1 | $PAGER'
alias -g L='| less'
alias -g LA='2>&1 | less'
alias -g M='| most'
alias -g C='| wc -l'


alias -s 1="man -l"
alias -s 2="man -l"
alias -s 3="man -l"
alias -s 4="man -l"
alias -s 5="man -l"
alias -s 6="man -l"
alias -s 7="man -l"


alias -s Dockerfile="docker build - < "

alias -s asc="gpg"
alias -s gpg="gpg"
alias -s pem="openssl x509 -noout -text -in "

alias -s json="jsonlint"
alias -s xml="xmllint --format"

alias -s md="editor"
alias -s txt="editor"

alias -s csv="vd"

alias -s jar="java -jar"
alias -s war="java -jar"

alias -s dot="dot -Tpng -O"
alias -s svg="xdg-open"
alias -s psd="xdg-open"

alias -s avi="xdg-open"
alias -s AVI="xdg-open"
alias -s flv="xdg-open"
alias -s gif="xdg-open"
alias -s jpeg="xdg-open"
alias -s jpg="xdg-open"
alias -s JPG="xdg-open"
alias -s m4v="xdg-open"
alias -s mkv="xdg-open"
alias -s mov="xdg-open"
alias -s mp3="xdg-open"
alias -s mp4="xdg-open"
alias -s MP4="xdg-open"
alias -s mpg="xdg-open"
alias -s ogg="xdg-open"
alias -s ogv="xdg-open"
alias -s png="xdg-open"
alias -s rmvb="xdg-open"
alias -s tif="xdg-open"
alias -s tiff="xdg-open"
alias -s webm="xdg-open"
alias -s wav="xdg-open"

alias -s doc="xdg-open"
alias -s docx="xdg-open"
alias -s epub="xdg-open"
alias -s html="xdg-open"
alias -s htm="xdg-open"
alias -s log="xdg-open"
alias -s odt="xdg-open"
alias -s ods="xdg-open"
alias -s odp="xdg-open"
alias -s pdf="xdg-open"
alias -s PDF="xdg-open"
alias -s ppt="xdg-open"
alias -s pptx="xdg-open"
alias -s pot="xdg-open"
alias -s rtf="xdg-open"
alias -s sla="xdg-open"
alias -s torrent="xdg-open"
alias -s xls="xdg-open"
alias -s xlsx="xdg-open"
alias -s xoj="xournal"

alias -s n3="rapper -i turtle --count"
alias -s nq="rapper -i nquads --count"
alias -s nt="rapper -i ntriples --count"
alias -s ntriple="rapper -i ntriples --count"
alias -s ntriples="rapper -i ntriples --count"
alias -s owl="rapper --count"
alias -s rdf="rapper --count"
alias -s trig="rapper -i trig --count"
alias -s tt="rapper -i turtle --count"
alias -s ttl="rapper -i turtle --count"

alias -s tjp="tj3"
