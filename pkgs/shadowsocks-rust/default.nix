{ stdenv
, fetchFromGitHub
, rustPlatform
, pkgconfig
, openssl                       # rust-openssl
, libsodium                     # libsodium-sys
}:

with rustPlatform;

buildRustPackage rec {
  name = "shadowsocks-rust-${version}";
  version = "20171021-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "9e4a5f8d44fe93c71f3f19c8df7af0b58095728f";

  cargoSha256 = "177s9h5myg57znxzdl2yqr13bq294qpqrzf1n71ybcq4xkz960nm";
  buildInputs = [ pkgconfig openssl libsodium ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "shadowsocks";
    repo = "shadowsocks-rust";
    sha256 = "13402w1da9yv3v1p9dhl08y5193l5386slqvinfss9ncrvq42sax";
  };

  meta = with stdenv.lib; {
    description = "A Rust port of shadowsocks";
    homepage = https://github.com/zonyitoo/shadowsocks-rust;
    license = with licenses; [ mit ];
    maintainers = [ ];
  };
}
