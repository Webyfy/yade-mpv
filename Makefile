RM = rm
Q = @

install:
	install -Dm755 usr/bin/umpv /usr/local/bin/mpv

uninstall: prerm
	$(RM) -f "/usr/bin/umpv"

.PHONY: install uninstall