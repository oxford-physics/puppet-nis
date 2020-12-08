# NIS
# ===
#
# Installs the package nis and libpam-unix2.
# Starts the service nis with status test -f /var/run/ypbind.pid.
# Adds the file /etc/yp.conf with content nis/etc/yp.conf.
# Adds the file /etc/defaultdomain with content $network.
# Adds the file /etc/pam.d/common-auth with content nis/etc/pam.d/common-auth.
# Executes /bin/echo '+::::::' >>/etc/passwd.
# Executes /bin/echo '+:::' >>/etc/group.
# Executes /bin/echo '+::::::::' >>/etc/shadow.
#
# Parameters
# $network
# Name of the network.
#
#Limitations - only one or two extra auth parameters - cant do array iteration and index storing
class nis::client ( 
   $nis_domain = $nis::params::nis_domain, 
   $servers  = $nis::params::servers,
   $ypbindport = $nis::params::ypbindport,
   $ypbindensure = $nis::params::ypbindensure,
   $ypbindenable = $nis::params::ypbindenable,
 
   ) inherits nis::params {


        $pname = $operatingsystem ? {
                     /(RedHat|CentOS|Fedora|Scientific)/ => "ypbind",
                     /Debian/ => "nis"
        } 

        package {"nis": 
                  name => "$pname",
                  ensure => installed 
        }
        service {"nis":
                name => $pname,
                ensure => $ypbindensure,
                enable => $ypbindenable,
                require => Package["nis"],
                status => "test -f /var/run/ypbind.pid"
        }

        file { "/etc/yp.conf":
                content => template("nis/etc/yp.conf"),
                require => Package["nis"],
                notify => Service["nis"]
       }

        file { "/etc/defaultdomain":
                content => "$nis_domain",
                require => Package["nis"],
                notify => Service["nis"]
        }
        file { "/etc/sysconfig/ypbind":
               content => "OTHER_YPBIND_OPTS=\"-p $ypbindport\"",
               require => Package["nis"],
               notify => Service["nis"],
        }
}
