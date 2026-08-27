# dotfiles

macOS configuration files for bash, Alacritty, AeroSpace, and git.

## Install

```sh
make install
```

Creates symlinks from this repo into the appropriate locations (`~/.bash_profile`, `~/.gitconfig`, `~/.gitignore_global`, `~/.config/alacritty/`, `~/.config/aerospace/`).

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
