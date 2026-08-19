{
  config,
  lib,
  pkgs,
  ...
}:
let
  runtimeLibraryPath = lib.makeLibraryPath [
    pkgs.glibc
    pkgs.zlib
    pkgs.stdenv.cc.cc.lib
  ];
  dynamicLinker = pkgs.stdenv.cc.bintools.dynamicLinker;
in
{
  config = lib.mkIf config.cli.enableRust {
    home.activation.rustupNixRuntime = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      toolchains_dir="${config.home.homeDirectory}/.rustup/toolchains"

      if [ -n "''${DRY_RUN_CMD:-}" ]; then
        echo "Would patch rustup toolchains for the current Nix runtime."
      elif [ -d "$toolchains_dir" ]; then
        patched_rpaths=0
        patched_interpreters=0

        while IFS= read -r -d "" elf; do
          current_rpath=$(${pkgs.patchelf}/bin/patchelf --print-rpath "$elf" 2>/dev/null) || continue
          current_interpreter=$(
            ${pkgs.patchelf}/bin/patchelf --print-interpreter "$elf" 2>/dev/null || true
          )

          needs_runtime_rpath=0
          case "$current_rpath" in
            */nix/store/*-glibc-*/lib*|*/nix/store/*-zlib-*/lib*|*/nix/store/*-gcc-*-lib/lib*|*/nix/store/*-gcc-*-libgcc/lib*|*/nix/store/*-xgcc-*-libgcc/lib*)
              needs_runtime_rpath=1
              ;;
          esac
          if ${pkgs.patchelf}/bin/patchelf --print-needed "$elf" 2>/dev/null \
            | ${pkgs.gnugrep}/bin/grep -qx "libz.so.1"; then
            needs_runtime_rpath=1
          fi

          next_rpath="$current_rpath"
          if [ "$needs_runtime_rpath" -eq 1 ]; then
            cleaned_rpath=""
            old_ifs="$IFS"
            IFS=:

            for entry in $current_rpath; do
              case "$entry" in
                /nix/store/*-glibc-*/lib|/nix/store/*-zlib-*/lib|/nix/store/*-gcc-*-lib/lib|/nix/store/*-gcc-*-libgcc/lib|/nix/store/*-xgcc-*-libgcc/lib)
                  continue
                  ;;
              esac

              if [ -n "$entry" ]; then
                if [ -n "$cleaned_rpath" ]; then
                  cleaned_rpath="$cleaned_rpath:$entry"
                else
                  cleaned_rpath="$entry"
                fi
              fi
            done

            IFS="$old_ifs"
            if [ -n "$cleaned_rpath" ]; then
              next_rpath="$cleaned_rpath:${runtimeLibraryPath}"
            else
              next_rpath="${runtimeLibraryPath}"
            fi
          fi

          update_rpath=0
          update_interpreter=0
          if [ "$current_rpath" != "$next_rpath" ]; then
            update_rpath=1
          fi
          if [ -n "$current_interpreter" ] && [ "$current_interpreter" != "${dynamicLinker}" ]; then
            update_interpreter=1
          fi
          if [ "$update_rpath" -eq 0 ] && [ "$update_interpreter" -eq 0 ]; then
            continue
          fi

          temporary="$elf.hm-nix-runtime.$$"
          if ! ${pkgs.coreutils}/bin/cp --reflink=auto --preserve=mode,timestamps "$elf" "$temporary"; then
            echo "Failed to copy $elf for Nix runtime patching." >&2
            exit 1
          fi
          if [ "$update_rpath" -eq 1 ] \
            && ! ${pkgs.patchelf}/bin/patchelf --set-rpath "$next_rpath" "$temporary"; then
            ${pkgs.coreutils}/bin/rm -f "$temporary"
            echo "Failed to patch RPATH for $elf." >&2
            exit 1
          fi
          if [ "$update_interpreter" -eq 1 ] \
            && ! ${pkgs.patchelf}/bin/patchelf --set-interpreter "${dynamicLinker}" "$temporary"; then
            ${pkgs.coreutils}/bin/rm -f "$temporary"
            echo "Failed to patch interpreter for $elf." >&2
            exit 1
          fi
          ${pkgs.coreutils}/bin/touch -r "$elf" "$temporary"
          if ! ${pkgs.coreutils}/bin/mv -f "$temporary" "$elf"; then
            ${pkgs.coreutils}/bin/rm -f "$temporary"
            echo "Failed to replace $elf after Nix runtime patching." >&2
            exit 1
          fi

          patched_rpaths=$((patched_rpaths + update_rpath))
          patched_interpreters=$((patched_interpreters + update_interpreter))
        done < <(
          ${pkgs.findutils}/bin/find "$toolchains_dir" \
            -type f \( -perm /111 -o -name "*.so" -o -name "*.so.*" \) -print0
        )

        echo "Updated $patched_rpaths rustup RPATHs and $patched_interpreters ELF interpreters for the current Nix runtime."
      fi
    '';
  };
}
