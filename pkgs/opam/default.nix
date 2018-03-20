{ stdenv, lib, fetchgit, fetchurl, makeWrapper,
  ocaml, unzip, ncurses, curl, aspcud, libcxx
}:

assert lib.versionAtLeast ocaml.version "4.02.3";

let
  deps = {
    "cppo.tar.gz" = fetchurl {
      url = "https://github.com/mjambon/cppo/archive/v1.6.0.tar.gz";
      sha256 = "068qmaga7wgvk3izsjfkmq2rb40vjgw7nv4d4g2w9w61mlih5jr9";
    };
    "extlib.tar.gz" = fetchurl {
      url = "https://github.com/ygrek/ocaml-extlib/releases/download/1.7.2/extlib-1.7.2.tar.gz";
      sha256 = "0r7mhfgh6n5chj9r12s2x1fxrzvh6nm8h80ykl1mr75j86za41bm";
    };
    "re.tar.gz" = fetchurl {
      url = "https://github.com/ocaml/ocaml-re/archive/1.7.1.tar.gz";
      sha256 = "1s3rcr76cgm4p1xmaazc58arkg2lz3zfcp1icm00m6s5ccnkh67b";
    };
    "cmdliner.tbz" = fetchurl {
      url = "http://erratique.ch/software/cmdliner/releases/cmdliner-1.0.2.tbz";
      sha256 = "18jqphjiifljlh9jg8zpl6310p3iwyaqphdkmf89acyaix0s4kj1";
    };
    "ocamlgraph.tar.gz" = fetchurl {
      url = "http://ocamlgraph.lri.fr/download/ocamlgraph-1.8.8.tar.gz";
      sha256 = "0m9g16wrrr86gw4fz2fazrh8nkqms0n863w7ndcvrmyafgxvxsnr";
    };
    "cudf.tar.gz" = fetchurl {
      url = "https://gforge.inria.fr/frs/download.php/file/36602/cudf-0.9.tar.gz";
      sha256 = "0771lwljqwwn3cryl0plny5a5dyyrj4z6bw66ha5n8yfbpcy8clr";
    };
    "dose3.tar.gz" = fetchurl {
      url = "https://gforge.inria.fr/frs/download.php/file/36063/dose3-5.0.1.tar.gz";
      sha256 = "00yvyfm4j423zqndvgc1ycnmiffaa2l9ab40cyg23pf51qmzk2jm";
    };
    "mccs.tar.gz" = fetchurl {
      url = "https://github.com/AltGr/ocaml-mccs/archive/1.1+5.tar.gz";
      sha256 = "0q9jnayz9j4bd5jvprd2x5gc9lgbzqscwhrnac09czdpgrkl97qy";
    };
    "opam-file-format.tar.gz" = fetchurl {
      url = "https://github.com/ocaml/opam-file-format/archive/2.0.0-beta5.tar.gz";
      sha256 = "12p3zpqbfqhkqwq308yfqr1iiq55q671gvk4sr55lx55fpc5lh2d";
    };
    "result.tar.gz" = fetchurl {
      url = "https://github.com/janestreet/result/archive/1.2.tar.gz";
      sha256 = "1pgpfsgvhxnh0i37fkvp9j8nadns9hz9iqgabj4dr519j2gr1xvw";
    };
    "jbuilder.tar.gz" = fetchurl {
      url = "https://github.com/janestreet/jbuilder/archive/1.0+beta16.tar.gz";
      sha256 = "1cy07pwvbrlysszs938yd74yyvvbgkffpb82qrjph77zf0h2gdi7";
    };
    "findlib.tar.gz" = fetchurl {
      url = "http://download.camlcity.org/download/findlib-1.7.3.tar.gz";
      sha256 = "12xx8si1qv3xz90qsrpazjjk4lc1989fzm97rsmc4diwla7n15ni";
    };
    "ocamlbuild.tar.gz" = fetchurl {
      url = "https://github.com/ocaml/ocamlbuild/archive/0.12.0.tar.gz";
      sha256 = "1qcw7fqkhzx1a3zgsqq2s3cpm7jsd7vwc92bhjb5hn0zjsm5dpnr";
    };
    "topkg.tbz" = fetchurl {
      url = "http://erratique.ch/software/topkg/releases/topkg-0.9.1.tbz";
      sha256 = "1slrzbmyp81xhgsfwwqs2d6gxzvqx0gcp34rq00h5iblhcq7myx6";
    };
  };
in stdenv.mkDerivation rec {
  name = "opam-${version}";
  version = "2.0.0-rc";

  buildInputs = [ unzip curl ncurses ocaml makeWrapper ];

  NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  src = fetchurl {
    url = "https://github.com/ocaml/opam/archive/2.0.0-rc.zip";
    sha256 = "05gv12qqmb47192n48205zglcxasydm1bhzm38z31bxc71hxgjf9";
  };

  postUnpack = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: src: ''
    ln -sv ${src} $sourceRoot/src_ext/${name}
  '') deps);

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
