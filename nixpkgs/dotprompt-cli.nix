final: prev: {
  dotprompt-cli = final.buildGoModule rec {
    pname = "dotprompt-cli";
    version = "unstable-2026-10-23";

    src = final.fetchFromGitHub {
      owner = "spicyneuron";
      repo = "dotprompt-cli";
      rev = "f16f7a2f212405cbb082112ff3baf9b2d40b4c69";
      hash = "sha256-d0O38+uuIawTxEuHCnLQNsuJ8paepIRvRS7auUR14cI=";
    };

    vendorHash = "sha256-JCJhAKR3zsg8CUs2iG2LfWMKLBgkjBi336kdPpnZNsU=";
    doCheck = false;

    meta = with final.lib; {
      description = "CLI runner for Google Dotprompt .prompt files";
      homepage = "https://github.com/spicyneuron/dotprompt-cli";
      license = licenses.mit;
      mainProgram = "dotprompt-cli";
    };
  };
}
