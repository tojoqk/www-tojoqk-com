bootstrap: serverless.yml main.rkt
	docker build -t www-tojoqk-com .
	docker run --rm \
                   --volume $$(pwd):/work \
                   --workdir /work \
                   www-tojoqk-com sh build.sh

.PHONY: deploy

deploy: bootstrap
	npm install
	./node_modules/serverless/bin/serverless deploy

production-deploy: bootstrap
	npm install
	./node_modules/serverless/bin/serverless --stage prd deploy
