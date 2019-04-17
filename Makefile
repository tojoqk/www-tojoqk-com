bootstrap: serverless.yml main.rkt
	docker build -t amazonlinux-racket .
	docker run --rm --volume $$(pwd):/work --workdir /work amazonlinux-racket sh build.sh

.PHONY: deploy

deploy: bootstrap
	docker build -t amazonlinux-racket .
	docker run --rm --volume $$(pwd):/work --workdir /work amazonlinux-racket sh deploy.sh
