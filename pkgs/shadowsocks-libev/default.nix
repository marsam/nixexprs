{ withMbedTLS ? true
, stdenv, fetchurl, zlib, autoreconfHook, fetchFromGitHub
, openssl ? null
, mbedtls ? null
, libev
, dnscrypt-proxy
, libsodium
, c-ares
, asciidoc
, xmlto
, docbook_xml_dtd_45
, docbook_xsl
, libxslt
, pcre
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "shadowsocks-libev-${version}";
  version = "3.1.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "shadowsocks";
    repo = "shadowsocks-libev";
    fetchSubmodules = true;
    sha256 = "0i9jar0b5d14fd2jw4hdsnw2isklgc1qqrrphg5r3mk2wjalyawd";
  };

  buildInputs = [ zlib asciidoc xmlto docbook_xml_dtd_45 docbook_xsl libxslt pcre libsodium c-ares libev dnscrypt-proxy ]
                ++ optional (!withMbedTLS) openssl
                ++ optional withMbedTLS mbedtls;

  nativeBuildInputs = [ autoreconfHook ];
  configureFlags = optional withMbedTLS [ "--with-mbedtls=${mbedtls}" ];

  NIX_CFLAGS_COMPILE = [
    "-isystem ${src}/libcork/include/"
    "-isystem ${src}/libipset/include/"
  ];

  meta = {
    description = "A lightweight secured SOCKS5 proxy";
    longDescription = ''
      Shadowsocks-libev is a lightweight secured SOCKS5 proxy for embedded
      devices and low-end boxes.  It is a port of Shadowsocks created by
      @clowwindy, which is maintained by @madeye and @linusyang.
    '';
    homepage = https://github.com/shadowsocks/shadowsocks-libev;
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
