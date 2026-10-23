{ inputs, ... }:
{
  configurations.home."sudha@0xnryn-laptop0" = {
    system = "x86_64-linux";
    module = {
      imports = [
        inputs.self.homeModules.sudha
      ];
    };
  };
  configurations.nixos = {
    "0xnryn-laptop0" = {
      system = "x86_64-linux";
      module = { modulesPath, pkgs, config, ... }:
      let hostName = "0xnryn-laptop0"; in
      {
        environment.sessionVariables = {
          TPM2TOOLS_TCTI = "device:/dev/tpmrm0";
        };
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        system.stateVersion = "26.05"; 
        time.timeZone = "Asia/Kolkata"; 
        i18n.defaultLocale = "en_US.UTF-8";
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = with pkgs; [
          vim nano wget git sops age home-manager nil nixd tpm2-tools sbctl tpm2-tss
          openssl pkg-config gcc tpm2-tss swtpm
        ];
        services = {
          printing.enable = true;
          libinput.enable = true;
          openssh.enable = true;  
          pipewire = {
            enable = true;
            pulse.enable = true;
          };
          power-profiles-daemon.enable = true;
        };
        hardware = {
          bluetooth.enable = true;
          graphics = {
            enable = true;
            enable32Bit = true;
          };
        };
        programs.nix-ld.enable = true;
        security.polkit.enable = true;
        security.tpm2.enable = true;
        security.tpm2.pkcs11.enable = true;
        nix.settings.trusted-users = [ "root" "sudha" ];
        networking = { networkmanager.enable = true; inherit hostName; };
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}.txt";
        users.users.sudha = { isNormalUser = true;
          extraGroups = [ "wheel" "docker" "dialout" "tss" ];
        };
        home-manager.users.sudha = {
          imports = [
            inputs.self.homeModules.sudha
          ];
        };
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.disko.nixosModules.disko
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "nvme-SAMSUNG_MZALQ512HBLU-00BL2_S65DNX2T624732" "15ach6-nvidia" 
          "amd-lanzaboote" "secrets" "networking" "plasma"
        ];
      };
    };
    "0xnryn-server" = {
      system = "x86_64-linux";
      module = { ... }:
      let hostName = "0xnryn-server"; in
      {
        networking = { networkmanager.enable = true; inherit hostName; };
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}";
        users.users.sudha = { isNormalUser = true;
          extraGroups = [ "wheel" "docker" ];
        };
        imports = [
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "generic-server" "secrets" "configuration" "networking"
        ];
      };
    };
  };
}
