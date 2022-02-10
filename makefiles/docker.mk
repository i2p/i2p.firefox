docker:
	docker build -t geti2p/i2p.firefox .

xhost:
	xhost + local:docker

run: docker xhost
	docker run -it --rm \
		--net=host \
		-e DISPLAY=unix$(DISPLAY) \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		geti2p/i2p.firefox firefox --profile /src/build/profile
