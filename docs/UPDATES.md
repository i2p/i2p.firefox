Setting up an Update Server for an I2P Bundle
=============================================

It is important to set up a signed update server so that people are able to
safely and anonymously update your I2P bundle.

The quick way:
--------------

This process depends on my ability to push releases to github. If you are
forking, setting up a dev server, or taking over because I got hit by a bus,
you'll need to do it the complete way.

For as long as I am building updates, you will be able to mirror the jpackaged
Windows bundle by cloning the repository `https://github.com/eyedeekay/i2p` and
running the `make docker run` target in that repository. You can retrieve the
base32 address of your update server by viewing the log with 
`docker logs eephttpd-jpackage | grep b32.i2p | tee eephttpd-address.md`. To
update the site, run `./update.site.sh` in that repository.

Once you have cloned the repository and started the container with
`make docker run`, you can simply add `path/to/repo/update-site.sh` to your
`crontab` and it will update at an interval of your choosing.

The complete way:
-----------------

TODO: describe how to do it with less of the awesome fancy stuff I put together
to make it easier on myself to keep an update server going.