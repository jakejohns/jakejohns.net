SRC_DIR := src
OUT_DIR := public

PANDOC := pandoc

MARKDOWN_FILES := $(shell find $(SRC_DIR) -type f -name '*.md')
HTML_FILES := $(patsubst $(SRC_DIR)/%.md, $(OUT_DIR)/%.html, $(MARKDOWN_FILES))

KEY_FILE := $(OUT_DIR)/key/jnj.asc
SIG := $(OUT_DIR)/index.html.asc

CSS_SOURCE := $(SRC_DIR)/style.css
CSS_OUTPUT := $(OUT_DIR)/asset/style.css

PANDOC_FLAGS := \
	--standalone \
	--to html \
	-M document-css=false \
	--css=asset/style.css

.PHONY: all clean serve deploy

all: $(HTML_FILES) $(CSS_OUTPUT) $(SIG)

$(OUT_DIR)/%.html: $(SRC_DIR)/%.md $(KEY_FILE)
	@mkdir -p $(@D)
	$(PANDOC) $< $(PANDOC_FLAGS) | ./bin/build.sh > $@

$(SIG): $(OUT_DIR)/index.html
	gpg --armor --detach-sign $<

$(KEY_FILE):
	gpg --export --armor $$KEY > $(KEY_FILE)

$(CSS_OUTPUT): $(CSS_SOURCE)
	@mkdir -p $(@D)
	cp $< $@

clean:
	$(RM) $(HTML_FILES) $(CSS_OUTPUT) $(KEY_FILE) $(SIG)

serve: all
	python3 -m http.server 8000 --directory $(OUT_DIR)
