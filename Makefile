MARATHON_TAG := v1.7.50

.PHONY: build-image
build-image:
	docker build -t marathon-build .

.PHONY: build-package
build-package: clean build-image
	git clone https://github.com/mesosphere/marathon.git
	cd marathon && git checkout ${MARATHON_TAG}
	docker run -e "DIST_UID=$(shell id -u)" -e "DIST_GID=$(shell id -g)" -v $(CURDIR)/marathon:/mnt:rw marathon-build

.PHONY: clean
clean:
	rm -rf marathon
