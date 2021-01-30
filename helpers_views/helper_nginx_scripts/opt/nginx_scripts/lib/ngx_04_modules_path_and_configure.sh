NGX_MODULE_PATH="/etc/nginx/modules"
set_ngx_module_path_and_mkdir () {
  # --- ngx configure argvs ---
  local ngx_argv_ori="$(nginx -V 2>&1 | grep configure | cut -d':' -f2- | xargs -n1 | grep -v 'dynamic')"

  local ngx_module_path="$(echo -e "${ngx_argv_ori}" |grep 'prefix' | cut -d'=' -f2-)/modules"

  local ngx_with_compat_found="$(echo -e "${ngx_argv_ori}" | grep 'with-compat')"

  # --- check and mkdir ---
  if [[ -n "${ngx_with_compat_found}" ]]; then
    # --- with-compat ---
    if [[ ! -e "${ngx_module_path}" ]]; then
      local ngx_lib_module_path="$(echo -e "${ngx_argv_ori}" |grep 'modules-path' | cut -d'=' -f2-)"

      echo "ln -s ${ngx_lib_module_path} ${ngx_module_path}"
      ln -s ${ngx_lib_module_path} ${ngx_module_path}
    fi
  else
    # --- no with-compat ---
    if [[ ! -d "${ngx_module_path}" ]]; then
      echo "mkdir \"${ngx_module_path}\""
      mkdir "${ngx_module_path}"

      echo "ln -s ${ngx_module_path} /etc/nginx/share_modules"
      ln -s ${ngx_module_path} /etc/nginx/share_modules
    fi
  fi

  # --- Set Nginx Modules Path ---
  NGX_MODULE_PATH="${ngx_module_path}"
  echo "NGX_MODULE_PATH=${NGX_MODULE_PATH}"
}


ngx_parse_and_configure_module () {
  local ngx_dynamic_module_folder="../${1}"
  # -----------------------------------------------------------------------------------------------------------
  # Change for installing Nginx using AppStream
  # -----------------------------------------------------------------------------------------------------------
  # --- parse out nginx configure arguments ---
  # Ref. https://serverfault.com/questions/223509/how-can-i-see-which-flags-nginx-was-compiled-with

  # --- build nginx compatible modules ---
  # Ref. https://gorails.com/blog/how-to-compile-dynamic-nginx-modules
  local ngx_current_configure_argv_ori="$(nginx -V 2>&1 | grep configure | cut -d':' -f2- | xargs -n1 | grep -v 'dynamic')"

  local ngx_current_configure_argv="$(echo -e "${ngx_current_configure_argv_ori}" | grep -vE 'with-cc-opt|with-ld-opt')"

  # special arguments with long details
  # ref. https://nginx.org/en/docs/configure.html

  # Success:
  local ngx_current_configure_argv_with_cc_opt="$(echo -e "${ngx_current_configure_argv_ori}" | grep 'with-cc-opt' | cut -d'=' -f2-)"
  local ngx_current_configure_argv_with_ld_opt="$(echo -e "${ngx_current_configure_argv_ori}" | grep 'with-ld-opt' | cut -d'=' -f2-)"
  # --- string with double quoted here will raise errors! ---
  # Fail:
  # ngx_current_configure_argv_with_cc_opt="--with-cc-opt=\"$(nginx -V 2>&1 | grep configure | cut -d':' -f2- | xargs -n1 | grep 'with-cc-opt' | cut -d'=' -f2-)\""
  # ngx_current_configure_argv_with_ld_opt="--with-ld-opt=\"$(nginx -V 2>&1 | grep configure | cut -d':' -f2- | xargs -n1 | grep 'with-ld-opt' | cut -d'=' -f2-)\""

  # -- special notice here ---
  # string with double quoted could only be placed here! Different arguments should be separated one by one.
  #     Because of bash variable mechanism, this separated configure arguments cannot be placed in variables,
  #     otherwise, bash will help you to escape special characters , such as ' \  and this will cause compliant fail
  # ARGV cannot be empty while ./configure, so specify different ./configure scenarios one by one
  # ARGV_with-ld_opt ARGV_with-id-opt should exist, otherwise some errors occurs
  if [[ -n "${ngx_current_configure_argv_with_cc_opt}" ]] && [[ -n "${ngx_current_configure_argv_with_ld_opt}" ]]; then
    ngx_current_configure_argv_with_cc_opt="--with-cc-opt=${ngx_current_configure_argv_with_cc_opt}"
    ngx_current_configure_argv_with_ld_opt="--with-ld-opt=${ngx_current_configure_argv_with_ld_opt}"
    set -x
    ./configure \
      "${ngx_current_configure_argv_with_cc_opt}" \
      "${ngx_current_configure_argv_with_ld_opt}" \
      ${ngx_current_configure_argv} \
      --add-dynamic-module=${ngx_dynamic_module_folder}
      # --add-dynamic-module=../headers-more-nginx-module-${PARAM_NGX_HEADERS_MORE_VER/v}
    set +x
  else
    echo "--------------------------------------------------------------------------"
    echo "Skip installing module !"
    echo "Some configure arguments not found: \"with-cc-opt\" or \"with-ld-opt\" !"
    echo "--------------------------------------------------------------------------"
    echo ""
  fi


  # --- works also ---
  # ngx_current_configure_argv_with_cc_opt="$(nginx -V 2>&1 | grep configure | cut -d':' -f2- | xargs -n1 | grep 'with-cc-opt' | cut -d'=' -f2-)"
  # ngx_current_configure_argv_with_ld_opt="$(nginx -V 2>&1 | grep configure | cut -d':' -f2- | xargs -n1 | grep 'with-ld-opt' | cut -d'=' -f2-)"
  # ./configure \
  #   --with-cc-opt="${ngx_current_configure_argv_with_cc_opt}" \
  #   --with-ld-opt="${ngx_current_configure_argv_with_ld_opt}" \
  #   ${ngx_current_configure_argv} \
  #   --add-dynamic-module=../headers-more-nginx-module-${PARAM_NGX_HEADERS_MORE_VER/v}

  # --- remind: configure arguments cannot be double quoted in one line (checkout nginx source configure script) ---
  # Fail:
  # ./configure "--xxxx --xxxx"
  # Success:
  # ./configure --xxxx --xxxx

  # --- Special cases found here in bash variables mechanism ---
  # variables in bash will always save in this way (single quoted, apostrophe, escape)
  # Script:
  # set -x
  # A=$"I'm"
  # echo "${A}"
  # ===>
  # ++ A='I'\''m'
  # ++ echo 'I'\''m'

  # --- xargs special usage ---
  # --delimiter
  # echo -e "a b\nc" |xargs -n1
  # a
  # b
  # c
  #
  # echo -e "a b\nc" |xargs -d '\n' -n1
  # a b
  # c

  # -----------------------------------------------------------------------------------------------------------
  # Failed , while install Nginx from AppStream becaulse no --with-compat in argv (nginx -V 2>&1 | grep compat)
  # -----------------------------------------------------------------------------------------------------------
  # => is not binary compatible
  #./configure --with-compat --add-dynamic-module=../headers-more-nginx-module-${PARAM_NGX_HEADERS_MORE_VER/v}

}

