RM = rm
Q = @

prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
MPV_CONFIG_DIR = /etc/mpv

ifneq (,$(findstring ${HOME},$(realpath ${prefix})))
	MPV_CONFIG_DIR = ${HOME}/.config/mpv
endif

MPV_CONFIG_DIR := $(DESTDIR)$(MPV_CONFIG_DIR)
bindir := $(DESTDIR)$(bindir)

preinst:
	mkdir -p "$(MPV_CONFIG_DIR)"
ifneq ("$(wildcard $(MPV_CONFIG_DIR)/mpv.conf)","")
	cp -n $(MPV_CONFIG_DIR)/mpv.conf $(MPV_CONFIG_DIR)/mpv.conf.ybak
endif

install: preinst
	install -Dm755 bin/umpv "$(bindir)/mpv"
	install -Dm644 conf/input.conf "$(MPV_CONFIG_DIR)/input.conf"
	install -Dm644 conf/mpv.conf "$(MPV_CONFIG_DIR)/mpv.conf"
	install -Dm644 conf/scripts/pause_on_focus_loss.lua "$(MPV_CONFIG_DIR)/scripts/pause_on_focus_loss.lua"
	install -Dm644 conf/scripts/visualizer.lua "$(MPV_CONFIG_DIR)/scripts/visualizer.lua"
	install -Dm644 conf/scripts/youtube-ui.lua "$(MPV_CONFIG_DIR)/scripts/youtube-ui.lua"

uninstall:
	$(RM) -f "$(bindir)/mpv"
	$(RM) -f "$(MPV_CONFIG_DIR)/input.conf"
	$(RM) -f "$(MPV_CONFIG_DIR)/mpv.conf"
	$(RM) -f "$(MPV_CONFIG_DIR)/scripts/pause_on_focus_loss.lua"
	$(RM) -f "$(MPV_CONFIG_DIR)/scripts/visualizer.lua"
	$(RM) -f "$(MPV_CONFIG_DIR)/scripts/youtube-ui.lua"
	$(MAKE) postrm

postrm:
ifneq ("$(wildcard $(MPV_CONFIG_DIR)/mpv.conf.ybak)","")
	mv -f $(MPV_CONFIG_DIR)/mpv.conf.ybak $(MPV_CONFIG_DIR)/mpv.conf
else
	echo "hwdec=vaapi" > $(MPV_CONFIG_DIR)/mpv.conf
endif

.PHONY: install uninstall preinst postrm