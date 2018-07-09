MARATHON_TAG := v1.6.496

.PHONY: build-image
build-image:
	docker build -t marathon-build .

.PHONY: build-package
build-package: build-image
	git clone https://github.com/mesosphere/marathon.git
	cd marathon && git checkout ${MARATHON_TAG}
	docker run -v $(CURDIR)/marathon:/opt/marathon:rw marathon-build

.PHONY: clean
clean:
	rm -rf marathon
