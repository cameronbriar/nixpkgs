{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, zlib, readline, openssl
, libiconv, pcsclite, libassuan, libXt
, docbook_xsl, libxslt, docbook_xml_dtd_412
, Carbon
}:

stdenv.mkDerivation rec {
  name = "opensc-${version}";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "OpenSC";
    rev = version;
    sha256 = "1shwx1rkmnygk2dp0q8pbvnxcg96bn570vch9yq34gs42ryskihf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoreconfHook zlib readline openssl pcsclite libassuan
    libXt libxslt libiconv docbook_xml_dtd_412
  ] ++ stdenv.lib.optional stdenv.isDarwin Carbon;

  configureFlags = [
    "--enable-zlib"
    "--enable-readline"
    "--enable-openssl"
    "--enable-pcsc"
    "--enable-sm"
    "--enable-man"
    "--enable-doc"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-xsl-stylesheetsdir=${docbook_xsl}/xml/xsl/docbook"
    "--with-pcsc-provider=${stdenv.lib.getLib pcsclite}/lib/libpcsclite.so"
  ];

  installFlags = [
    "sysconfdir=$(out)/etc"
  ];

  meta = with stdenv.lib; {
    description = "Set of libraries and utilities to access smart cards";
    homepage = https://github.com/OpenSC/OpenSC/wiki;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ viric wkennington ];
    platforms = platforms.all;
  };
}
