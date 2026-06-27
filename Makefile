UPSTREAM := https://github.com/nwg-piotr/nwg-drawer.git
UPSTREAM_BRANCH := main

.PHONY: setup update regen-patches get build install uninstall run

setup:
	git remote add upstream $(UPSTREAM) || true
	git fetch upstream $(UPSTREAM_BRANCH)

update:
	git fetch upstream $(UPSTREAM_BRANCH)
	git rebase upstream/$(UPSTREAM_BRANCH)
	git am patches/*.patch
	$(MAKE) build

regen-patches:
	mkdir -p patches
	git format-patch upstream/$(UPSTREAM_BRANCH) -o patches/ --no-stat

get:
	go get github.com/diamondburned/gotk4/pkg/gdk/v3
	go get github.com/diamondburned/gotk4/pkg/glib/v2
	go get github.com/diamondburned/gotk4/pkg/gtk/v3
	go get github.com/diamondburned/gotk4-layer-shell/pkg/gtklayershell
	go get github.com/joshuarubin/go-sway
	go get github.com/allan-simon/go-singleinstance
	go get github.com/sirupsen/logrus
	go get github.com/fsnotify/fsnotify

build:
	go build -v -o bin/nwg-drawer .

install:
	-pkill -f nwg-drawer
	sleep 1
	mkdir -p /usr/share/nwg-drawer
	cp -r desktop-directories /usr/share/nwg-drawer
	cp -r img /usr/share/nwg-drawer
	cp drawer.css /usr/share/nwg-drawer
	cp bin/nwg-drawer /usr/bin

	install -Dm 644 -t "/usr/share/licenses/nwg-drawer" LICENSE
	install -Dm 644 -t "/usr/share/doc/nwg-drawer" README.md

uninstall:
	rm -r /usr/share/nwg-drawer
	rm /usr/bin/nwg-drawer

run:
	go run .
