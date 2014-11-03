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
   ) inherits nis::params {


        $pname = $operatingsystem ? {
                     /(Red Hat|CentOS|Fedora|Scientific)/ => "ypbind",
                    Debian => "nis",} 

        package {"nis": 
                  name => "$pname",
                  ensure => installed 
	}
        service {"nis":
                name => $pname,
                ensure => running,
                enable => true,
                require => Package["nis"],
                status => "test -f /var/run/ypbind.pid"
        }

        file { "/etc/yp.conf":
                content => template("${module_name}/etc/yp.conf"),
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

   #TODO - copy in nsswitch if it doesnt exist
   notify {"Warning: Nis client module does not manage rpcbind":}
}
