#!/usr/bin/env bash

if ! command -v emacs &>/dev/null; then
  if [[ $(uname -o) == "Darwin" ]]; then
    brew install emacs

  elif [[ $(uname -o) == "Android" ]]; then
    apt update
    apt install -y emacs

  else

    . /etc/os-release

    if [[ "$ID" == "fedora" && "$VARIANT_ID" != "silverblue" && "$VARIANT_ID" != "kinoite" ]]; then
      dnf check-update
      sudo dnf install -y emacs

    elif [[ "$VARIANT_ID" == "silverblue" || "$VARIANT_ID" == "kinoite" ]]; then
      sudo rpm-ostree install --apply-live -y emacs

    elif [ "$ID_LIKE" = "opensuse suse" ]; then
      sudo zypper refresh
      sudo zypper --non-interactive --no-confirm install emacs

    elif [[ "$ID" == "debian" || "$ID_LIKE" == "debian" || "$ID_LIKE" == "ubuntu debian" ]]; then
      sudo apt update
      sudo apt install -y emacs

    elif [ "$ID_LIKE" = "arch" ]; then
      sudo pacman -Sy --noconfirm emacs

    fi
  fi
fi

EMACS_VERSION="$(emacs --version | head -n 1 | cut -d' ' -f 3)"
EMACS_INIT_DIRECTORY="$HOME/.opt/spacemacs"

if [ ! -d $HOME/.opt/spacemacs ]; then
  mkdir -p $HOME/.config
  mkdir -p $HOME/.opt/spacemacs
  git clone --depth 1 https://github.com/syl20bnr/spacemacs EMACS_INIT_DIRECTORY/.emacs.d
fi

cat <<'EOF' >~/.local/bin/spacemacs
#!/usr/bin/env bash

emacs --init-directory=$HOME/.opt/spacemacs/.emacs.d $@
EOF
chmod +x ~/.local/bin/spacemacs
