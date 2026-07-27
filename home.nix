{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  #### Nix will install these for me
  # home.packages = with pkgs; [
  #   # cli i use constantly
  #   ripgrep    # fast search
  #   fd         # fast find
  #   fzf        # fuzzy finder
  #   jq         # json on the command line
  #   lazygit
  #   neovim
  #   # the font everything renders in
  #   nerd-fonts.hack
  # ];

  #### home-manager will generate zsh files based on below config
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "prompt-spacing";
        src = ./home/.config/zsh/plugins/prompt-spacing;
      }
    ];

    # profileExtra = ''
    #   eval "$(/opt/homebrew/bin/rbenv init - --no-rehash zsh)"
    # '';

    initContent = ''
      bindkey '^f' autosuggest-accept # tab accept auto-suggest

      # history
      HISTFILE="$HOME/.zsh_history"
      HISTSIZE=1000000
      SAVEHIST=1000000
      setopt share_history
      setopt extended_history
      setopt hist_verify

      # Emacs-style line editing
      bindkey -e

      # 输入部分命令后，用 ↑ / ↓ 搜索对应历史
      bindkey "^[[A" history-search-backward
      bindkey "^[[B" history-search-forward

      # Ctrl-X Ctrl-E：用 $EDITOR 编辑当前命令行
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey "^X^E" edit-command-line

      # Local, mutable overrides that are intentionally not managed by Nix.
      [[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
    '';

    shellAliases = {
      vim = "nvim";
      vi = "nvim";

      # python = "python3";
      # pip = "pip3";

      # basics
      l = "ls -alFh";
      ".." = "cd ..";
      cd = "z";

      # git
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";

      # agent
      # cc = "claude --dangerously-skip-permissions";
      # co = "codex --full-auto";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.amp/bin"
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;

    settings = {
      include.path = "~/.config/git/corp";
      includeIf."gitdir:~/d/".path = "~/.config/git/personal";

      init.defaultBranch = "main";
    };
  };

  home.file.".config/git/corp".text = ''
    [user]
      name = weijianduan
      email = weijian.duan@inspiregroup.com
  '';

  home.file.".config/git/personal".text = ''
    [user]
      name = weijianduan
      email = weijianduan0302@gmail.com
  '';

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = { };

    extraConfig = ''
      Host github-personal
          HostName github.com
          User git
          IdentityFile ~/.ssh/id_ed25519_personal
          IdentitiesOnly yes
          AddKeysToAgent yes
          IgnoreUnknown UseKeychain
          UseKeychain yes
    '';
  };

  programs.starship = {
    enable = true;

    enableZshIntegration = true;

    settings = {
      add_newline = false;

      directory = {
        truncation_length = 0;
        truncate_to_repo = false;
        style = "bold blue";
      };

      git_status = {
        conflicted = "=$count ";
        ahead = "⇡$count ";
        behind = "⇣$count ";
        diverged = "⇕⇡$ahead_count⇣$behind_count ";
        up_to_date = "✓ ";
        untracked = "?$count ";
        stashed = "S$count ";
        modified = "!$count ";
        staged = "+$count ";
        renamed = "»$count ";
        deleted = "-$count ";

        format = "([$all_status$ahead_behind]($style) )";
        style = "bold yellow";
      };

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };
    };
  };

  # Edit-in-place: the real life stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".config/lazygit".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/lazygit";
  home.file.".config/karabiner".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/karabiner";
  home.file.".snipaste/config.ini".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.snipaste/config.ini";

  # Global AGENTS.md
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
