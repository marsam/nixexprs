{ stdenv
, buildPythonPackage
, fetchgit
, requests
}:
buildPythonPackage rec {
  name = "downgur-${version}";
  rev = "1cefcfe31bbfe70dbf0600890c7b58e855e7bdfe";
  version = "20171206-${stdenv.lib.strings.substring 0 7 rev}";

  propagatedBuildInputs = [ requests ];

  src = fetchgit {
    inherit rev;
    url = https://gist.github.com/e43303a9142c6a28bd399d18714d94cc.git;
    sha256 = "02j4y2z0c82v421z8hlk3v25fap5njsd2288hy7klglzc50h1x0c";
  };

  meta = {
    description = "Download albums from imgur";
    license = stdenv.lib.licenses.mit;
  };
}
