# NOTE: please keep your version of sass up to date: sudo gem update
.PHONY: watch css
SASS_FILES=$(wildcard addons/*/static/src/css/*.sass openerp/addons/*/static/src/css/*.sass)
CSS_FILES=$(patsubst %.sass,%.css,${SASS_FILES})
css: ${CSS_FILES}
%.css: %.sass
	sass -t expanded --compass --unix-newlines --sourcemap=none $< $@
watch:
	sass -t expanded --compass --unix-newlines --sourcemap=none --watch .:.
# build:
#     docker compose up -d --build
# shell_root:
#     docker compose exec -u root -ti web bash
# shell:
#     docker compose exec web bash
