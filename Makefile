RM = rm
Q = @

prefix = /usr
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
MPV_CONFIG_DIR = /etc/mpv

ifneq (,$(findstring ${HOME},$(realpath ${prefix})))
	MPV_CONFIG_DIR = ${HOME}/.config/mpv
endif

MPV_CONFIG_DIR := $(DESTDIR)$(MPV_CONFIG_DIR)
bindir := $(DESTDIR)$(bindir)

preinst:
ifneq ("$(wildcard $(MPV_CONFIG_DIR)/mpv.conf)","")
	cp -n $(MPV_CONFIG_DIR)/mpv.conf $(MPV_CONFIG_DIR)/mpv.conf.ybak
endif

install-only:
	install -Dm755 yade-mpv/usr/bin/umpv "$(bindir)/umpv"
	install -Dm644 yade-mpv/etc/mpv/input.conf "$(MPV_CONFIG_DIR)/input.conf"
	install -Dm644 yade-mpv/etc/mpv/mpv.conf "$(MPV_CONFIG_DIR)/mpv.conf"
	install -Dm644 yade-mpv/etc/mpv/scripts/pause_on_focus_loss.lua "$(MPV_CONFIG_DIR)/scripts/pause_on_focus_loss.lua"
	install -Dm644 yade-mpv/etc/mpv/scripts/visualizer.lua "$(MPV_CONFIG_DIR)/scripts/visualizer.lua"
	install -Dm644 yade-mpv/etc/mpv/scripts/youtube-ui.lua "$(MPV_CONFIG_DIR)/scripts/youtube-ui.lua"

postinst:
ifneq (,$(findstring ${HOME},$(realpath ${prefix})))
	ln -s -r $(bindir)/umpv $(bindir)/mpv
else
	update-alternatives --install /usr/local/bin/mpv mpv $(bindir)/umpv 100
endif

install:
	$(Q)$(MAKE) preinst
	$(Q)$(MAKE) install-only
	$(Q)$(MAKE) postinst

prerm:
ifneq (,$(findstring ${HOME},$(realpath ${prefix})))
	$(RM) -f $(bindir)/mpv
else
	update-alternatives --remove mpv $(bindir)/umpv
endif

uninstall-only:
	$(RM) -f "$(bindir)/umpv"
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

uninstall:
	$(Q)$(MAKE) prerm
	$(Q)$(MAKE) uninstall-only
	$(Q)$(MAKE) postrm

clean:
	git clean -fdX

.PHONY: preinst install-only postinst install prerm uninstall-only postrm clean
