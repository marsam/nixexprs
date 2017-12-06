{ stdenv, fetchFromGitHub, ocamlPackages, }:

stdenv.mkDerivation rec {
  name = "kremlin-${version}";
  version = "20170714-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "1dbacde77f5b5dcc46d6321c0bb77932a0ed96d2";

  src = fetchFromGitHub {
    inherit rev;
    owner = "FStarLang";
    repo = "kremlin";
    sha256 = "192sb4xfgj892dw8bd6apincp8a19ph5l3pdzqhp7q3f5lq1v281";
  };

  buildInputs = with ocamlPackages; [
    ocaml findlib pprint menhir process fix wasm
  ];
  propagatedBuildInputs = with ocamlPackages; [
    ppx_deriving ppx_deriving_yojson zarith ulex ocamlbuild
  ];
  createFindlibDestdir = true;

  installPhase = ''
    install -Dm755 Kremlin.native $out/bin/krml
  '';

  meta = with stdenv.lib; {
    description = "KreMLin is a tool for extracting low-level F* programs to readable C code";
    license = licenses.asl20;
    platforms = ocaml.meta.platforms or [];
    maintainers = [];
  };

}
