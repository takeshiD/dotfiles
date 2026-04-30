return {
	cmd = { "neocmakelsp", "stdio" },
	filetypes = { "cmake" },
	root_markers = { ".neocmake.toml", ".git", "build", "cmake" },
	settings = {
		neocmake = {
			init_options = {
				format = {
					enable = true, -- to use lsp format
				},
				lint = {
					enable = true,
				},
				scan_cmake_in_package = true, -- it will deeply check the cmake file which found when search cmake packages.
				semantic_token = true,
			},
		},
	},
}
