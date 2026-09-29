#!/usr/bin/env bash

keyfile=public/key/jnj.asc

keyid=$(gpg --with-colons --show-keys "$keyfile" | awk -F: '/^pub:/ { print $5 }')

get_expiry() {
    gpg --show-keys --with-colons "$keyfile" |
    awk -F: '$1 == "pub" {
        if ($7 == "" || $7 == "0")
            print "does not expire"
        else
            print strftime("%Y-%m-%d", $7)
    }'
}

expiry=$(get_expiry)

fpr=$(gpg --show-keys --with-colons "$keyfile" | awk -F: '$1 == "fpr" { f=$10; gsub(/..(..)/, "& ", f); print f; exit }' )

updated=$(date -Is)

sed \
    -e "s/<!-- KEYID -->/$keyid/" \
    -e "s/EXPIRY/$expiry/" \
    -e "s/FPR/$fpr/" \
    -e "s/UPDATED/$updated/"
