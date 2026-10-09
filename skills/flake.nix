{
  description = "Agent Skills to download from third party sources";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    agentSkills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cavemanSkills = {
      url = "github:JuliusBrussee/caveman";
      flake = false;
    };
    ponytailSkills = {
      url = "github:DietrichGebert/ponytail";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      agentSkills,
      cavemanSkills,
      ponytailSkills,
      ...
    }:
    let
      agentLib = agentSkills.lib.agent-skills;

      # Single source of truth, shared by the buildEnv bundle (packages.default)
      # and the home-manager module.
      sources = {
        caveman = {
          path = cavemanSkills;
          subdir = "skills";
        };
        ponytail = {
          path = ponytailSkills;
          subdir = "skills";
        };
        adaliszk = {
          path = self;
          subdir = ".";
        };
      };
      enabledSkills = [
        "caveman"
        "caveman-review"
        "ponytail"
        "ponytail-review"
        "swe-task"
        "swe-story"
        "swe-decision"
      ];

      # Build the selection once; it is system-independent.
      catalog = agentLib.discoverCatalog sources;
      allowlist = agentLib.allowlistFor {
        inherit catalog sources;
        enable = enabledSkills;
      };
      selection = agentLib.selectSkills {
        inherit catalog allowlist sources;
      };

      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          bundle = agentLib.mkBundle {
            inherit pkgs selection;
            name = "adaliszk-agent-skills";
          };
        in
        {
          # `bundle` lays skills out as <skill-id>/SKILL.md at its root. Nest it
          # under share/agent-skills/skills so it can be merged into a buildEnv
          # (e.g. the agentdev profile) without scattering skill dirs across the
          # profile root. Point an agent at it with, for example:
          #   ln -s ~/.nix-profile/share/agent-skills/skills ~/.claude/skills
          default = pkgs.runCommand "adaliszk-agent-skills-env" { } ''
            mkdir -p "$out/share/agent-skills"
            ln -s ${bundle} "$out/share/agent-skills/skills"
          '';
          inherit bundle;
        }
      );

      # Kept for home-manager consumers; reuses the same sources/selection.
      homeManagerModules.default = {
        imports = [ agentSkills.homeManagerModules.default ];
        programs.agent-skills = {
          enable = true;
          inherit sources;
          skills.enable = enabledSkills;
          targets.claude.enable = true;
          targets.opencode.enable = true;
        };
      };
    };
}
