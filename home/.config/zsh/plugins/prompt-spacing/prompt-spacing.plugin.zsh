# Keep one empty line between prompts while treating a cleared terminal as fresh.
typeset -gi _prompt_spacing_fresh=1
typeset -g _prompt_spacing_preexec_cmd

_prompt_spacing_preexec() {
  _prompt_spacing_preexec_cmd=$2
}

_prompt_spacing_precmd() {
  local -i command_status=$?
  emulate -L zsh -o extended_glob

  if [[ ${_prompt_spacing_preexec_cmd-} ==
        [[:space:]]#(clear([[:space:]]##-(|x)(|T[a-zA-Z0-9-_\'\"]#))#|reset)[[:space:]]# ]] &&
      (( command_status == 0 )); then
    _prompt_spacing_fresh=1
  fi

  if (( _prompt_spacing_fresh )); then
    _prompt_spacing_fresh=0
  else
    print
  fi

  unset _prompt_spacing_preexec_cmd
  return command_status
}

typeset -ga preexec_functions precmd_functions
preexec_functions=(${preexec_functions:#_prompt_spacing_preexec} _prompt_spacing_preexec)
precmd_functions=(_prompt_spacing_precmd ${precmd_functions:#_prompt_spacing_precmd})
