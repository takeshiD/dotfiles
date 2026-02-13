{ lib, ... }:
{
  options.cli = {
    enableCore = lib.mkEnableOption "core";
    enableGit = lib.mkEnableOption "git";
    enableContainer = lib.mkEnableOption "container";
    enableMisc = lib.mkEnableOption "misc";
    enableWsl = lib.mkEnableOption "wsl";
    enableGcc = lib.mkEnableOption "gcc";
    enableClang = lib.mkEnableOption "clang";
    enableRust = lib.mkEnableOption "rust";
    enablePython = lib.mkEnableOption "python";
    enableGo = lib.mkEnableOption "golang";
    enableNodejs = lib.mkEnableOption "nodejs";
    enableLsp = lib.mkEnableOption "lsp";
  };
}
