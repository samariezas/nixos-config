{
  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      europa UUID=6d1a4508-cf58-4639-a39b-ba0cf058da47 /root/crypt/europa nofail,noauto,luks
    '';
  };
}
