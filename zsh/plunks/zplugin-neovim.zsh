
function zplg-setup-neovim () {
  # neovim linux appimage on x64
  if [[ $unamearch == "x86_64" ]]; then
    if [[ $unamestr == "Linux" ]]; then
      zplugin ice nocompletions from"gh-r" bpick"*.appimage" \
        as"program" mv"nvim.appimage -> nvim" pick"nvim" id-as'neovim'
      zplugin load neovim/neovim
    elif [[ $unamestr == "Darwin" ]]; then
      # not yet implemented
    fi
  fi

  function zplg-remove-neovim () {
    zplugin unload neovim
    rm -rf ${ZPLGM[PLUGINS_DIR]}/neovim
    rehash
  }
}
# manage it if it's already there
[[ -d ${ZPLGM[PLUGINS_DIR]}/neovim ]] && {
  zplg-setup-neovim
}
