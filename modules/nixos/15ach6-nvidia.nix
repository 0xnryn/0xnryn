{ ... }:
{
  flake.nixosModules."15ach6-nvidia" = { config, lib, pkgs, modulesPath, ... }:
  {
    services.xserver.videoDrivers = [ 
      "amdgpu" 
      "nvidia" 
    ];
    hardware = {
      nvidia = {
        modesetting.enable = true;
        open = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        # dynamicBoost.enable = true;
        nvidiaSettings = true;        
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime = {
          offload.enable = true;
          offload.enableOffloadCmd = true;
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };
  };
}
  
