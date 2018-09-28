MD_FILES=$(shell find . -name \*.md)
HTML_FILES=$(MD_FILES:.md=.html)
BUILD_HTML_FILES=$(HTML_FILES:%=build/%)

all: $(BUILD_HTML_FILES)

build/%.html: %.md
	@echo Making $@
	@mkdir -p $$(dirname $@)
	cat $? | sed -E 's/\]\(([-a-zA-Z0-9_\/]+)\)/](\1\.html)/' | pandoc -s -f markdown -t html --template=github -o $@

build/assets/%: assets/%
	@mkdir -p $$(dirname $@)
	cp $? $@
