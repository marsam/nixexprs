{ stdenv, fetchFromGitHub, readline, yacc, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "es-${version}";
  version = "20170815-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "92a103e009f41c9290ea88f37e78506bd11642f9";

  src = fetchFromGitHub {
    inherit rev;
    owner = "jpco";
    repo = "es-shell";
    sha256 = "1j716ac6plpsbfnswmykj074xrznrcw0byf4gbd8n65sdl31xczr";
  };

  preConfigure = ''
    aclocal
    autoconf
    libtoolize -qi
  '';

  nativeBuildInputs = [ libtool autoconf automake yacc ];
  buildInputs = [ readline ];
  configureFlags = [ "--with-readline" ];

  meta = with stdenv.lib; {
    description = "Es is an extensible shell";
    homepage = https://github.com/jpco/es-shell;
    longDescription = ''
      Es is an extensible shell. The language was derived
      from the Plan 9 shell, rc, and was influenced by
      functional programming languages, such as Scheme,
      and the Tcl embeddable programming language.
    '';
    license = licenses.publicDomain;
    platforms = platforms.all;
  };

  passthru = {
    shellPath = "/bin/es";
  };
}
