{ ... }:
{
  flake.nixosModules.ollama = { config, lib, pkgs, ... }:
  {
    services = {
      ollama = {
        enable = true;
        # package = pkgs.ollama-cuda;
        environmentVariables = {
          OLLAMA_FLASH_ATTENTION = "1";
          OLLAMA_KV_CACHE_TYPE = "q4_0"; # Compresses KV cache to 4-bit to save RAM
        };
      };
    };

  };
}
  
