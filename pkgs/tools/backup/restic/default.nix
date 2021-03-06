{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "restic-${version}";
  version = "0.8.2";

  goPackagePath = "github.com/restic/restic";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${version}";
    sha256 = "1prk8r0kmcscj79fc53a0qjvik6ygjr50xwnahs0amlyh03pyb46";
  };

  buildPhase = ''
    cd go/src/${goPackagePath}
    go run build.go
  '';

  installPhase = ''
    mkdir -p \
      $bin/bin \
      $bin/etc/bash_completion.d \
      $bin/share/zsh/vendor-completions \
      $bin/share/man/man1
    cp restic $bin/bin/
    $bin/bin/restic generate \
      --bash-completion $bin/etc/bash_completion.d/restic.sh \
      --zsh-completion $bin/share/zsh/vendor-completions/restic.sh \
      --man $bin/share/man/man1
  '';

  meta = with stdenv.lib; {
    homepage = https://restic.github.io;
    description = "A backup program that is fast, efficient and secure";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = [ maintainers.mbrgm ];
  };
}
