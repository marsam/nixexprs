{ stdenv, fetchFromGitHub, Carbon, Cocoa }:

stdenv.mkDerivation rec {
  name = "chunkwm-${version}";
  version = "0.2.36";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "koekeishiya";
    repo = "chunkwm";
    sha256 = "0xb01m9sl9dpa2r2rprhf3ipyy44xf5wafssr84rq1hdvhkk0yb5";
  };

  buildInputs = [ Carbon Cocoa ];

  meta = with stdenv.lib; {
    platforms = platforms.darwin;
  };
}
