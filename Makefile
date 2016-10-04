build-base:
	docker build -f hardcaml-docs-base -t hardcaml-docs-base .

rebuild-base:
	docker build --no-cache -f hardcaml-docs-base -t hardcaml-docs-base .

build: build-base
	docker build -f hardcaml-docs -t hardcaml-docs .

rebuild: build-base
	docker build --no-cache -f hardcaml-docs -t hardcaml-docs .

test:
	docker run --name hardcaml-docs-server -p 127.0.0.1:7777:7777 hardcaml-docs \
		opam config exec -- cohttp-server-lwt -p 7777 /home/opam/.opam/4.03.0/var/cache/odig/odoc

stop-test:
	docker stop hardcaml-docs-server
	docker rm hardcaml-docs-server

DATE=$(shell date)

copy:
	-git rm -fr odoc/
	mkdir odoc
	echo foo > odoc/foo
	docker create --name hardcaml-docs-copy hardcaml-docs
	docker cp hardcaml-docs-copy:/home/opam/.opam/4.03.0/var/cache/odig/odoc .
	docker rm hardcaml-docs-copy
	git add odoc
	git commit -a -m "docs generate at $(DATE)"

