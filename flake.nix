{
  description = "NixOS & Home Manager configuration";
  nixConfig = {
    extra-substituters = [
      "https://cache.numtide.com"
      "https://ros.cachix.org"
      "https://takeshid.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
      "takeshid.cachix.org-1:2GsGTUZ3djVzbGzXgeia+SRV1ZJYOXySHyNfBPsEjRA="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # my tools
    tmux-deck.url = "github:takeshid/tmux-deck";
    markdown-peek.url = "github:takeshid/markdown-peek/v0.1.9";
    ioskeley-mono-jp.url = "github:takeshid/IoskeleyMonoJP";
    # thirdparty
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    gfm-preview.url = "github:thiagokokada/gh-gfm-preview";
    llm-agents.url = "github:numtide/llm-agents.nix";
    ob-fish.url = "github:takeshid/ob.fish";
    markdown-tui-explorer.url = "github:leboiko/markdown-reader";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-wsl,
      nix-index-database,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # flake は既定で pure eval のため getEnv は空文字列になる。
      # 素通しすると分かりにくい失敗をするので、明示的に落とす。
      requireEnv =
        name:
        let
          value = builtins.getEnv name;
        in
        if value == "" then
          throw "環境変数 ${name} を取得できません。--impure を付けて実行してください。"
        else
          value;
    in
    {
      nixosConfigurations = {
        "snowcat" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./nixos/snowcat
          ];
          specialArgs = {
            inherit (inputs) ioskeley-mono-jp;
          };
        };
      };
      homeConfigurations = {
        "tkcd@snowcat" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            nix-index-database.homeModules.nix-index
            ./hosts/snowcat.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
        "tkcd@doppio" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            nix-index-database.homeModules.nix-index
            ./hosts/doppio.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
        # 利用者名やホスト名をこのリポジトリに残したくない環境向け。
        # 実行時の $USER / $HOME から解決するため --impure が必要。
        #   home-manager switch --flake .#local --impure
        "local" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            nix-index-database.homeModules.nix-index
            ./hosts/doppio.nix
            {
              home.username = requireEnv "USER";
              home.homeDirectory = requireEnv "HOME";
              dotfiles.enableTmuxLocal = true;
            }
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
