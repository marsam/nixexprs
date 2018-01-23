{ stdenv
, bash
, coreutils
, less
, fetchFromGitHub
, managerPath ? null
}:

stdenv.mkDerivation rec {
  name = "home-manager";
  version = "20171102-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "21fefbc8f6f1c0c496414df8ad9c4e578ed4d8e4";

  src = fetchFromGitHub {
    inherit rev;
    owner = "rycee";
    repo = "home-manager";
    sha256 = "00nx3fncmx6h65rjmm8hsgj0mzpfl3i799ch754vj2kgsrr9n5gw";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    install -v -D -m755 ${src}/home-manager/home-manager $out/bin/home-manager
    substituteInPlace $out/bin/home-manager \
      --subst-var-by bash "${bash}" \
      --subst-var-by coreutils "${coreutils}" \
      --subst-var-by less "${less}" \
      --subst-var-by HOME_MANAGER_PATH '${if managerPath == null then "${src}/modules" else managerPath}'
    '';

  meta = with stdenv.lib; {
    description = "A user environment configurator";
    homepage = "https://github.com/rycee/home-manager";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
