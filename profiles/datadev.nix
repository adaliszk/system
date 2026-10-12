{
  pkgs,
  jetbrainsPlugins,
  ...
}:

let
  dataspell = jetbrainsPlugins.lib.buildIdeWithPlugins pkgs "dataspell" [
    "net.codestats.plugin.atom.intellij"
    "com.chylex.intellij.inspectionlens"
    "com.clutcher.comments_highlighter"
    "indent-rainbow.indent-rainbow"
    "lermitage.intellij.extra.icons"
  ];
in
pkgs.buildEnv {
  name = "datadev";
  paths = with pkgs; [
    dataspell
    python314
    python314Packages.uv
    pipenv
  ];
}
