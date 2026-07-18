{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = "weijianduan";
  home.homeDirectory = "/Users/weijianduan";
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

  #### home-manager is gonna take over zsh for me
  #### use when ready
  # programs.zsh {
  #   enable = true;
  #   autosuggestion.enable = true;   # ghost text from history
  #   syntaxhighlighting.enable = true;   # commands turn green when valid
  #   initContent = ''
  #     bindkey '^f' autosuggest-accept
  #   '';
  #   shellAliases = {
  #     ".." = "cd ..";
  #     add = "git add .";
  #     push = "git push";
  #     pull = "git pull";
  #     m = "git switch main";
  #     cc = "claude --gangerously-skip-permissions";
  #     co = "codex --full-auto";
  #   };
  # };

  # programs.git.settings.user = {
  #   name = "weijianduan";
  #   email = "weijianduan0302@gmail.com";
  # };

  # fonts.fontconfig.enable = true;
  # home.sessionVariables.EDITOR = "nvim";

  # Edit-in-place: the real life stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".config/lazygit".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/lazygit";
  # Global AGENTS.md
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
