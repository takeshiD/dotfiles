# Pi extensions

TypeScript files (`.ts`) or directories with an `index.ts` here are linked into
`~/.pi/agent/extensions/` by `home/pi.nix` and loaded by Pi on startup.
Because they are linked to this repository and not copied to the Nix store,
edits apply with `/reload` and do not need a `home-manager switch`.

Third-party Pi packages (extensions plus skills and prompts) belong in the
`dotfiles.pi.packages` option instead, for example `pkgs/pi-subagents`.
