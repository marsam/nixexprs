{ stdenv, lib, fetchgit, fetchurl, makeWrapper,
  ocaml, unzip, ncurses, curl, aspcud
}:

assert lib.versionAtLeast ocaml.version "4.02.3";

let
  srcs = {
    cppo = fetchurl {
      url = "https://github.com/mjambon/cppo/archive/v1.5.0.tar.gz";
      sha256 = "06b8lck5n0jg1c7a43d7g7r4sb05i1gjva7h52cm43fsf3addih0";
    };
    extlib = fetchurl {
      url = "https://github.com/ygrek/ocaml-extlib/releases/download/1.7.2/extlib-1.7.2.tar.gz";
      sha256 = "0r7mhfgh6n5chj9r12s2x1fxrzvh6nm8h80ykl1mr75j86za41bm";
    };
    ocaml_re = fetchurl {
      url = "https://github.com/ocaml/ocaml-re/archive/1.7.1.tar.gz";
      sha256 = "1s3rcr76cgm4p1xmaazc58arkg2lz3zfcp1icm00m6s5ccnkh67b";
    };
    cmdliner = fetchurl {
      url = "http://erratique.ch/software/cmdliner/releases/cmdliner-1.0.0.tbz";
      sha256 = "1ryn7qis0izg0wcal8zdlikzzl689l75y6f4zc6blrm93y5agy9x";
    };
    ocamlgraph = fetchurl {
      url = "http://ocamlgraph.lri.fr/download/ocamlgraph-1.8.7.tar.gz";
      sha256 = "1845r537swjil2fcj7lgbibc2zybfwqqasrd2s7bncajs83cl1nz";
    };
    cudf = fetchurl {
      url = "https://gforge.inria.fr/frs/download.php/file/36602/cudf-0.9.tar.gz";
      sha256 = "0771lwljqwwn3cryl0plny5a5dyyrj4z6bw66ha5n8yfbpcy8clr";
    };
    dose3 = fetchurl {
      url = "https://gforge.inria.fr/frs/download.php/file/36063/dose3-5.0.1.tar.gz";
      sha256 = "00yvyfm4j423zqndvgc1ycnmiffaa2l9ab40cyg23pf51qmzk2jm";
    };
    mccs = fetchurl {
      url = "https://github.com/AltGr/ocaml-mccs/archive/1.1+4.tar.gz";
      sha256 = "00kyxc7nxlv4adk5z9afwvkw80n1lk1cpg3diawz7zz7hi2qk3n3";
    };
    opam_file_format = fetchurl {
      url = "https://github.com/ocaml/opam-file-format/archive/2.0.0-beta5.tar.gz";
      sha256 = "12p3zpqbfqhkqwq308yfqr1iiq55q671gvk4sr55lx55fpc5lh2d";
    };
    result = fetchurl {
      url = "https://github.com/janestreet/result/archive/1.2.tar.gz";
      sha256 = "1pgpfsgvhxnh0i37fkvp9j8nadns9hz9iqgabj4dr519j2gr1xvw";
    };
    jbuilder = fetchurl {
      url = "https://github.com/janestreet/jbuilder/archive/08050696fb701dafcd1372aadfaa800a50bc01ca.tar.gz";
      sha256 = "0d4dc3b3111f4p1rxhfsk1wiv067559nr6npixvvws6wlpv27j3z";
    };
    opam = fetchurl {
      url = "https://github.com/ocaml/opam/archive/2.0.0-beta5.zip";
      sha256 = "0hld1r2ivvlwl58v8b6lb3wrxw4k3jcis6qjpwxinf4jw2x6mk4b";
    };
  };
in stdenv.mkDerivation rec {
  name = "opam-${version}";
  version = "2.0.0-beta5";

  buildInputs = [ unzip curl ncurses ocaml makeWrapper ];

  src = srcs.opam;

  postUnpack = ''
    ln -sv ${srcs.cppo} $sourceRoot/src_ext/${srcs.cppo.name}
    ln -sv ${srcs.extlib} $sourceRoot/src_ext/${srcs.extlib.name}
    ln -sv ${srcs.ocaml_re} $sourceRoot/src_ext/${srcs.ocaml_re.name}
    ln -sv ${srcs.cmdliner} $sourceRoot/src_ext/${srcs.cmdliner.name}
    ln -sv ${srcs.ocamlgraph} $sourceRoot/src_ext/${srcs.ocamlgraph.name}
    ln -sv ${srcs.cudf} $sourceRoot/src_ext/${srcs.cudf.name}
    ln -sv ${srcs.dose3} $sourceRoot/src_ext/${srcs.dose3.name}
    ln -sv ${srcs.mccs} $sourceRoot/src_ext/${srcs.mccs.name}
    ln -sv ${srcs.opam_file_format} $sourceRoot/src_ext/${srcs.opam_file_format.name}
    ln -sv ${srcs.result} $sourceRoot/src_ext/${srcs.result.name}
    ln -sv ${srcs.jbuilder} $sourceRoot/src_ext/${srcs.jbuilder.name}
  '';

  preConfigure = ''
    substituteInPlace ./src_ext/Makefile --replace "%.stamp: %.download" "%.stamp:"
  '';

  postConfigure = "make lib-ext";

  postInstall = ''
    wrapProgram $out/bin/opam \
      --suffix PATH : ${aspcud}/bin
  '';

  meta = with stdenv.lib; {
    description = "A package manager for OCaml";
    homepage = https://opam.ocaml.org/;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
