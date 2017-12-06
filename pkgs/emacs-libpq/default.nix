{ stdenv, fetchgit, emacs, postgresql }:

stdenv.mkDerivation rec {
  name = "emacs-libpq-${version}";
  version = "20170331-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "cbdff81a90b877a632f5b47ca3aed974f3b9449f";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/anse1/emacs-libpq";
    sha256 = "1cyqdsap24r8bfiv47khz2qnnjj0y8yi3qjrvl4sdqxr5hmd9fxk";
  };

  buildInputs = [ emacs ];
  propagatedBuildInputs = [ postgresql ];
  NIX_CFLAGS_COMPILE = [
    "-I${emacs}/share/emacs/${emacs.version}/src/"
    "-I${postgresql}/include"
  ];
  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install pq.so $out/share/emacs/site-lisp
  '';
}
