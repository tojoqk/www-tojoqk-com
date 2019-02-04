bootstrap: serverless.yml main.rkt
	raco exe --orig-exe -o bootstrap serverless.yml

.PHONY: deploy

deploy: bootstrap
	sls deploy
