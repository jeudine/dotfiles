BASH_PROFILE     := $(HOME)/.bash_profile
GITCONFIG        := $(HOME)/.gitconfig
GITIGNORE_GLOBAL := $(HOME)/.gitignore_global
ALACRITTY        := $(HOME)/.config/alacritty/alacritty.toml
AEROSPACE        := $(HOME)/.config/aerospace/aerospace.toml
NVIM_COLEMAK     := $(HOME)/.config/nvim/lua/plugins/colemak.lua

.PHONY: install clean

install: $(BASH_PROFILE) $(GITCONFIG) $(GITIGNORE_GLOBAL) $(ALACRITTY) $(AEROSPACE) $(NVIM_COLEMAK)

$(BASH_PROFILE): bash_profile
	ln -sf $(PWD)/$< $@

$(GITCONFIG): gitconfig
	ln -sf $(PWD)/$< $@

$(GITIGNORE_GLOBAL): gitignore_global
	ln -sf $(PWD)/$< $@

$(ALACRITTY): alacritty/alacritty.toml
	mkdir -p $(dir $@)
	ln -sf $(PWD)/$< $@

$(AEROSPACE): aerospace/aerospace.toml
	mkdir -p $(dir $@)
	ln -sf $(PWD)/$< $@

$(NVIM_COLEMAK): nvim/colemak.lua
	mkdir -p $(dir $@)
	ln -sf $(PWD)/$< $@

clean:
	rm -f $(BASH_PROFILE) $(GITCONFIG) $(GITIGNORE_GLOBAL) $(ALACRITTY) $(AEROSPACE) $(NVIM_COLEMAK)
