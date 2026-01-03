IMAGE_NAME=docker-gs-ping-roach

docker-build:
	docker build -t $(IMAGE_NAME) .

docker-run-roach:
	docker run -d --rm \
	--name roach \
	--hostname db \
	--network mynet \
	-p 26257:26257 \
	-p 8080:8080 \
	-v roach:/cockroach/cockroach-data \
	cockroachdb/cockroach:latest-v25.4 start-single-node \
	--insecure

docker-run:
	docker run -it --rm -d \
	--network mynet \
	--name rest-server \
	-p 8081:8080 \
	-e PGUSER=totoro \
	-e PGPASSWORD=myfriend \
	-e PGHOST=db \
	-e PGPORT=26257 \
	-e PGDATABASE=mydb \
	$(IMAGE_NAME)

post-request:
	curl --request POST \
	--url http://localhost:8081/send \
	--header 'content-type: application/json' \
	--data '{"value": "Hello, Docker!"}'

docker-push:
	docker push $(IMAGE_NAME)

clean:
	rm -rf bin

#docker exec -it roach ./cockroach sql --insecure
#CREATE DATABASE mydb;
#CREATE USER totoro;
#GRANT ALL ON DATABASE mydb TO totoro;

