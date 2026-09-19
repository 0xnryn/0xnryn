{
  # Declares flake inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    multiverse.url = "github:fzakaria/nixpkgs-multiverse";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nryn-laptop.url = "github:0xnryn/nryn-laptop";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [ 
      (inputs.import-tree ./modules) 
      inputs.cosmic.flakeModules.default
    ];
  };
}


v