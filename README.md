## Overview
This repo is a follow along to Kun Chen's tutorial of setting up reproducible dev setup using Nix configuration system
    - Video: [L8 Principal's Agentic Dev Environment From Scratch](https://www.youtube.com/watch?v=5N-okeDdIuI)
    - His Repo: [kunchenguid/dotfiles](https://github.com/kunchenguid/dotfiles)

## Todos before I stablize this config as my own

**Nix**
- [ ] `whoami` output is hardcoded in multiple places now
- [ ] macOS setup not done
    - darkmode incompatible with WeChat
- some existing config file not migrate yet
    - [ ] .zshrc
    - [ ] .tmux.conf
- homebrew not migrate fully

**Neovim**
- [ ] I still have some recent vim config not migrating to neovim config
- some plugin needs to deep dive
    - Oil.nvim: I want file tree along with buffer, so find ways to config
    - Snakes.nvim: fuzzyfinder has similar feature, so which one is better
    - some vim plugin

**Herdr**
- [ ] can `|` be used as shortcut key?
- [ ] vim tmux navigator can't be used in herdr now
- [ ] need some crash course on herdr basics
