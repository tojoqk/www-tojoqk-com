bootstrap: serverless.yml *.rkt
	docker build -t www-tojoqk-com .
	docker run --rm \
                   --volume $$(pwd):/work \
                   --workdir /work \
                   www-tojoqk-com sh build.sh

.PHONY: deploy production-deploy

deploy: bootstrap
	npm install
	STAGE=development ./node_modules/serverless/bin/serverless deploy

production-deploy: bootstrap
	npm install
	STAGE=production ./node_modules/serverless/bin/serverless deploy
