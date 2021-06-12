build:
	@docker build -t anuwong/simple-go .

start:
	@docker run --rm --name simple-go -d -p 3000:3000 anuwong/simple-go

stop:
	@docker stop simple-go

release:
	@docker push anuwong/simple-go
