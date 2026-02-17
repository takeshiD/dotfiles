return {
	cmd = { "nixd" },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "(import <nixpkgs/nixos> {})",
			},
			formatting = {
				command = { "nixfmt" },
			},
			options = {
				-- nixos = {
				-- 	expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
				-- },
				-- home_manager = {
				-- 	expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
				-- },
			},
		},
	},
}
