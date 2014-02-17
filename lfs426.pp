# PREREQ: puppet module install puppetlabs/vcsrepo


define download ($uri, $timeout = 300) {
  exec {
      "download $uri":
          command => "wget -q '$uri' -O $name",
          creates => $name,
          timeout => $timeout,
          require => Package[ "wget" ],
      }
}
#Use it like:
#download {
#  "/tmp/tomcat.tar.gz":
#          uri => "http://www.ibiblio.org/pub/mirrors/",
#          timeout => 900;
#}                                                                                                                }





###################################################################

Package { ensure => "installed" }

$common = [	"strace", "sudo", "wget", "screen", "git", "binutils", 
		"gcc", "autoconf", "automake", "m4", "mc","gcc-c++", "gcc-fortran", 
		"bonnie", "bonnie++", 
	]


$lf426  = [ "memtest86+", "", "" ]

$lf331  = [ "binutils",]

package { $common: }

