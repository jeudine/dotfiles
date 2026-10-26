# dotfiles

macOS configuration files for bash, Alacritty, AeroSpace, git, and Neovim (AstroNvim).

## Install

```sh
make install
```

Creates symlinks from this repo into the appropriate locations (`~/.bash_profile`, `~/.gitconfig`, `~/.gitignore_global`, `~/.config/alacritty/`, `~/.config/aerospace/`, `~/.config/nvim/lua/plugins/colemak.lua`).

## Neovim on Colemak-DH

`nvim/colemak.lua` is linked into an existing AstroNvim config at `~/.config/nvim`. It moves the
movement keys from h/j/k/l to m/n/e/i, the keys in the same physical spots (and the keyboard's arrow
layer). The keys this pushes out move to h/j/k/l; the full table is at the top of that file.

## Git identity

`gitconfig` deliberately contains no name or email. It includes `~/.gitconfig.local`,
which is kept outside this repo, so the identity is never committed.

Create it on each machine:

```sh
cat > ~/.gitconfig.local <<'EOF'
[user]
	name = your name
	email = you@example.com
EOF
```

Git ignores a missing include, so nothing breaks without it — but git will refuse to
commit until an identity is set somewhere.

## Remove

```sh
make clean
```

Removes the symlinks only. `~/.gitconfig.local` is left untouched.
