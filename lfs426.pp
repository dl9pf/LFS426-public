

# ... and even combine it a global package parameter
Package { ensure => "installed" }

$lf426pkg = [	"screen", "git", "binutils", "gcc",
		"autoconf", "automake", "m4", "mc",
		"gcc-c++", "gcc-fortran", "bonnie",
		"bonnie++", ]

package { $lf426pkg: }