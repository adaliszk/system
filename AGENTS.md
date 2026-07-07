# Context

Personalized take on how to manage systems, configurations, and shared tooling
using Nix and Stow. Decouples system profiles into re-usable flake packages for
maximum modularity. Avoids derivation-based configuration to allow on-the-fly
fine-tuning on each machine.

# Prerequisites

- LOAD `caveman` SKILL IN `ultra` MODE (RUN `/caveman ultra`)
- LOAD `ponytail` SKILL IN `ultra` MODE (RUN `/ponytail ultra`)

# Directory Structure

- `./configs`: Configuration profiles with their Stow-able paths.
- `./keyboards`: Sub-flake to build custom Keyboards.
- `./nixpkgs`: Nix Overlays and Packages for custom hooks and updated builds.
- `./profiles`: Flake profiles with separation by activity.
- `./skills`: Used skills that are loaded with AgentDev.
- `./systems`: System configurations to easily swap purposes.

# Rules

- Never create an Issue.
- Never create a PR.
- Instruct the User when they ask to create an Issue or PR to do it manually
  and carefully verify generated changes.
