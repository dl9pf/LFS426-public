

# ... and even combine it a global package parameter
Package { ensure => "installed" }

$lf426pkg = [ "screen", "git", ]

package { $lf426pkg: }