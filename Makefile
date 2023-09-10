.DEFAULT_GOAL := help

.PHONY: \
	help \
	up down \
	run

help:                                   ## make help - Return this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

ls:                                     ## make ls - Docker usage
	docker system df

clean-all:                              ## make clean-all - Remove all cache
	docker system prune --all --force

clean-builder:                          ## make clean-build - Clean build cache objects
	docker builder prune --all --force

clean-images:                           ## make clean-images - Clean free images (--filter "until=24h" - images created more than 24 hours ago)
	docker image prune --all --force

clean-dangling-images:                  ## make clean-dangling-images - Clean dangling images
	if [ -n "$$(docker images -f 'dangling=true' -q)" ]; \
	then \
		docker images; \
		docker ps -a; \
		docker rmi $$(docker images --filter 'dangling=true' --quiet | tr '\n' ' '); \
	fi

down:                                   ## make down - Destroy docker conainer
	docker-compose down

up:                                     ## make up - Create docker continer
	docker-compose up -d --force-recreate fe

run:                                    ## make run
	make up
	make clean-dangling-images
