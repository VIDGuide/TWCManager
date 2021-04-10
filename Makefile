DEPS := lighttpd screen git
SUDO := sudo
VER := $(shell lsb_release -sr)

build: deps setup

deps:
	$(SUDO) apt-get update

ifeq ($(VER), 9.11)
	$(SUDO) apt-get install -y $(DEPS) php7.0-cgi
else ifeq ($(VER), stretch)
	$(SUDO) apt-get install -y $(DEPS) php7.0-cgi
else ifeq ($(VER), 16.04)
	$(SUDO) apt-get install -y $(DEPS) php7.0-cgi
else ifeq ($(VER), 16.10)
	$(SUDO) apt-get install -y $(DEPS) php7.0-cgi
else ifeq ($(VER), 20.04)
	$(SUDO) apt-get install -y $(DEPS) php7.4-cgi
else
	$(SUDO) apt-get install -y $(DEPS) php7.3-cgi
endif
	$(SUDO) lighty-enable-mod fastcgi-php ; exit 0
	$(SUDO) service lighttpd force-reload

install: deps

	$(SUDO) lighty-enable-mod fastcgi-php ; exit 0
	$(SUDO) service lighttpd force-reload

	$(SUDO) cp html/* /var/www/html/
	$(SUDO) chown -R www-data:www-data /var/www/html
	$(SUDO) chmod -R 755 /var/www/html
	$(SUDO) usermod -a -G www-data pi

	# Install TWCManager packages
	$(SUDO) ./setup.py install

	# Create configuration directory
	$(SUDO) mkdir -p /etc/twcmanager
ifeq (,$(wildcard /etc/twcmanager/config.json))
	$(SUDO) cp etc/twcmanager/config.json /etc/twcmanager/
endif
	$(SUDO) chown root:pi /etc/twcmanager -R
	$(SUDO) chmod 775 /etc/twcmanager

testconfig:
	# Create configuration directory
	$(SUDO) mkdir -p /etc/twcmanager
ifeq (,$(wildcard /etc/twcmanager/.testconfig.json))
	$(SUDO) cp etc/twcmanager/.testconfig.json /etc/twcmanager/
endif
	$(SUDO) chown root:pi /etc/twcmanager -R
	$(SUDO) chmod 775 /etc/twcmanager

setup:
	# Install TWCManager packages
	$(SUDO) python3 setup.py install
