{ pkgs, ... }:
{
  users.users.ollama = {
    isNormalUser = true;
    description = "Ollama";
    uid = 1002;
    packages = [ pkgs.ollama ];
  };
}
