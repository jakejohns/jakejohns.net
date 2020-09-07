MAKEFLAGS += --no-builtin-rules --no-builtin-variables --warn-undefined-variables
.DELETE_ON_ERROR :

pub_dir=public
bin_dir=bin
tmp_dir=tmp

REMOTE=jnj:./www

htmls = $(shell find $(pubdir) -type f -name \*.html)
sigs = $(patsubst %.html,%.html.asc,$(htmls))

ts_index = $(tmp_dir)/ts-index
index=$(pub_dir)/index.html

timestamp=$(bin_dir)/timestamp
deploy=$(bin_dir)/deploy


all: $(ts_index) $(sigs)

$(tmp_dir) :
	mkdir -p $@

$(ts_index) : $(index) | $(tmp_dir)
	$(timestamp) < $< > $<.tmp
	mv $<.tmp $<
	touch $@

%.html.asc: %.html
	gpg --armor --detach-sign $<

.PHONY : deploy
deploy : all
	$(deploy) $(pub_dir)/ $(REMOTE)
