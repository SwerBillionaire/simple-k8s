gen-hex:
	@openssl rand -hex 4

build:
	@docker build -t anuwong/simple-go:$(TAG) .
	@docker build -t anuwong/simple-go:latest .

start:
	@docker run --rm --name simple-go -d -p 3000:3000 anuwong/simple-go:latest

stop:
	@docker stop simple-go

release:
	@docker push anuwong/simple-go:$(TAG)
	@docker push anuwong/simple-go:latest

deploy:
	$(eval TAG := $(shell make gen-hex))
	@make build TAG=$(TAG)
	@make release TAG=$(TAG)
	@kubectl set image deployment/go-app-deployment simple-go=anuwong/simple-go:$(TAG)

benchmark:
	@wrk -t8 -c8 -d30s -s post.lua $(URL)
