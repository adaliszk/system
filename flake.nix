{
  description = "System Profiles & Configurations by AdaLiszk, btw";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flakeUtils.url = "github:numtide/flake-utils";
    systemManager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jetbrainsPlugins = {
      url = "github:theCapypara/nix-jetbrains-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agentTools = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    skills = {
      url = "path:./skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      systemManager,
      flakeUtils,
      jetbrainsPlugins,
      agentTools,
      treefmt,
      skills,
      ...
    }:
    flakeUtils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          config.allowUnfree = true;
          inherit system;
          overlays = [
            (import ./nixpkgs/lan-mouse.nix)
            (import ./nixpkgs/llama-turboquant-cpu.nix)
            (import ./nixpkgs/llama-turboquant-rocm.nix)
            (import ./nixpkgs/llama-turboquant-cuda.nix)
            (import ./nixpkgs/codegraph.nix)
            (import ./nixpkgs/dotprompt-cli.nix)
          ];
        };
        importNix =
          dir: name:
          import (dir + "/${name}.nix") {
            inherit
              pkgs
              system
              systemManager
              jetbrainsPlugins
              agentTools
              ;
            skills = skills.packages.${system}.default;
          };
        systemNames = map (pkgs.lib.removeSuffix ".nix") (builtins.attrNames (builtins.readDir ./systems));
        systems = pkgs.lib.genAttrs systemNames (name: (importNix ./systems name).system);
        profileNames = map (pkgs.lib.removeSuffix ".nix") (
          builtins.attrNames (builtins.readDir ./profiles)
        );
        profiles = pkgs.lib.genAttrs profileNames (importNix ./profiles);
        treefmtEval = treefmt.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
            dprint.enable = true;
            shfmt.enable = true;
          };
        };
      in
      {
        systemConfigs = systems;
        packages = profiles // {
          default = profiles.essentials;
          lan-mouse = pkgs.lan-mouse;
          llama-turboquant-cpu = pkgs.llama-turboquant-cpu;
          llama-turboquant-rocm = pkgs.llama-turboquant-rocm;
          llama-turboquant-cuda = pkgs.llama-turboquant-cuda;
          codegraph = pkgs.codegraph;
          dotprompt-cli = pkgs.dotprompt-cli;
        };
        formatter = treefmtEval.config.build.wrapper;
        checks.formatting = treefmtEval.config.build.check self;
        devShells.default = pkgs.mkShell {
          packages = [
            treefmtEval.config.build.wrapper
            pkgs.dprint
            pkgs.nufmt
          ];
        };
      }
    )
    // {
      inherit (skills) homeManagerModules;
    };
}
