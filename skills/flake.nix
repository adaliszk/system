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
    karpathySkills = {
      url = "github:swarmclawai/andrej-karpathy-skills";
      flake = false;
    };
    superpowersSkills = {
      url = "github:obra/superpowers";
      flake = false;
    };
    addyosmaniSkills = {
      url = "github:addyosmani/agent-skills";
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
      karpathySkills,
      superpowersSkills,
      addyosmaniSkills,
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
        karpathy = {
          path = karpathySkills;
          subdir = "skills";
        };
        superpowers = {
          path = superpowersSkills;
          subdir = "skills";
          # Only consumed via explicit `from`+`path` below, never by discovery.
          # Namespace its catalog ids so collisions with other sources (e.g.
          # `test-driven-development`, also shipped by addyosmani) can't break
          # `discoverCatalog`, which scans every source and rejects any dup id.
          idPrefix = "superpowers";
        };
        addyosmani = {
          path = addyosmaniSkills;
          subdir = "skills";
        };
        adaliszk = {
          path = self;
          subdir = ".";
        };
      };
      # Third-party skills, selected by discovered id from their sources.
      # Each has a tracking marker at ./<id>/.upstream (folders without a
      # SKILL.md are invisible to discovery, so they never collide).
      enabledSkills = [
        "caveman"
        "caveman-review"
        "ultracave"
        "ponytail"
        "ponytail-review"
        "idea-refine"
      ];

      # Skills installed under an id that differs from their discovered id.
      # The attribute name is the final id; `from` is the source key and `path`
      # is relative to that source's subdir.
      explicitSkills = {
        # Own skills, authored in this repo (source `adaliszk`, subdir ".").
        swe-task = {
          from = "adaliszk";
          path = "swe-task";
        };
        swe-story = {
          from = "adaliszk";
          path = "swe-story";
        };
        swe-decision = {
          from = "adaliszk";
          path = "swe-decision";
        };
        mdq = {
          from = "adaliszk";
          path = "mdq";
        };
        dotprompt = {
          from = "adaliszk";
          path = "dotprompt";
        };

        # Third-party skills installed under a renamed id.
        karpathy = {
          from = "karpathy";
          path = "karpathy-guidelines";
        };
        idea-brainstorm = {
          from = "superpowers";
          path = "brainstorming";
        };
        plan-write = {
          from = "superpowers";
          path = "writing-plans";
        };
        plan-breakdown = {
          from = "addyosmani";
          path = "planning-and-task-breakdown";
        };
        context-optimize = {
          from = "addyosmani";
          path = "context-engineering";
        };
        swe-review-quality = {
          from = "addyosmani";
          path = "code-review-and-quality";
        };
        swe-simplify = {
          from = "addyosmani";
          path = "code-simplification";
        };
        swe-worktree = {
          from = "superpowers";
          path = "using-git-worktrees";
        };
      };

      # Build the selection once; it is system-independent.
      catalog = agentLib.discoverCatalog sources;
      allowlist = agentLib.allowlistFor {
        inherit catalog sources;
        enable = enabledSkills;
      };
      selection = agentLib.selectSkills {
        inherit catalog allowlist sources;
        skills = explicitSkills;
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
          skills.explicit = explicitSkills;
          targets.claude.enable = true;
          targets.opencode.enable = true;
        };
      };
    };
}
