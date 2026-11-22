{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage (finalAttrs: {
  pname = "pi-subagents";
  version = "0.89.2";

  src = fetchzip {
    url = "https://registry.npmjs.org/${finalAttrs.pname}/-/${finalAttrs.pname}-${finalAttrs.version}.tgz";
    # nix store prefetch-file --hash-type sha256 "<url>"
    hash = "sha256-V84wRt/k3OpKJUCMopBejOfOFRRbCcyCPChnBy2+V40=";
    stripRoot = true;
  };

  # The published npm tarball has no lockfile, so `fetchNpmDeps` needs one.
  # Regenerate with:
  #   npm install --package-lock-only --ignore-scripts
  # then update npmDepsHash:
  #   nix run nixpkgs#prefetch-npm-deps -- package-lock.json
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-eRBPyq0cehWZY9a4gWgBT2vTgcOOrXMVdtzd0WD5iNM=";

  # The tarball already ships the esbuild bundle in ./bundle.
  dontNpmBuild = true;

  # Never vendor @earendil-works/* or typebox: Pi maps those imports to its
  # own copies at runtime.
  npmInstallFlags = [ "--omit=dev" ];

  # buildNpmPackage installs to $out/lib/node_modules/<name>; Pi needs that
  # directory (the one with package.json) as the package root.
  passthru.piPackage = "${finalAttrs.finalPackage}/lib/node_modules/${finalAttrs.pname}";

  meta = {
    description = "Pi extension for single-agent delegation and scripted multi-agent workflows";
    homepage = "https://github.com/nicobailon/pi-subagents";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
