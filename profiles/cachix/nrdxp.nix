{
  nix.settings = {
    substituters = [
      "https://nrdxp.cachix.org"
    ];
    trusted-public-keys = [
      "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
    ];
  };
  # nix = {
  #   binaryCaches = [
  #     "https://nrdxp.cachix.org"
  #   ];
  #   binaryCachePublicKeys = [
  #     "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
  #   ];
  # };
}
