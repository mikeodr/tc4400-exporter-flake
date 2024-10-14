{
  description = "Prometheus exporter for the Technicolor TC4400 DOCSIS 3.1 cable modem";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs =
    { self
    , nixpkgs
    , ...
    }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      overlay = _: prev: { inherit (self.packages.${prev.system}) tc4400_exporter; };

      packages = forAllSystems
        (system:
          let
            pkgs = nixpkgsFor.${system};
          in
          {
            tc4400_exporter = pkgs.buildGo122Module
              rec {
                pname = "tc4400_exporter";
                version = "0.0.1";

                src = pkgs.fetchFromGitHub {
                  owner = "mikeodr";
                  repo = "tc4400_exporter";
                  rev = "daa0eacf062abf3acf9ad8ea40142b28029b3a35";
                  hash = "sha256-ElVYw5gCIMHJsQjdKT5NBDmMODj3WR424ZTKupAa0x4=";
                };

                vendorHash = "sha256-IQS5DE1/r+qPTg4qxuU9LcGPJpJLe6cdL9tgPHk6MHE";

                meta = with pkgs.lib; {
                  description = "Prometheus exporter for the Technicolor TC4400 DOCSIS 3.1 cable modem";
                  homepage = "https://github.com/mikeodr/tc4400_exporter";
                  license = pkgs.lib.licenses.asl20;
                  maintainers = with maintainers; [ mikeodr ];
                };
              };
          });

      defaultPackage = forAllSystems (system: self.packages.${system}.tc4400_exporter);

      imports = [ ./tc4400_exporter.nix ];
    };
}
