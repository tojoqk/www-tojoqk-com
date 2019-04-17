build:
	docker build -t amazonlinux-racket .

bootstrap: serverless.yml main.rkt
	docker run --rm --volume $$(pwd):/work --workdir /work amazonlinux-racket sh build.sh

.PHONY: deploy

deploy: bootstrap
	docker run --rm --volume $$(pwd):/work --workdir /work amazonlinux-racket sh deploy.sh
