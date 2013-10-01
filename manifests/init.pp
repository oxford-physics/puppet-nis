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
class nis::client ( $network, $extraauth="nis", $extraauth2="none" ) {
        $this_profile = "$module_name"
        $pname = $operatingsystem ? {
                     /(Red Hat|CentOS|Fedora|Scientific)/ => "ypbind",
                    Debian => "nis",} 

        package {"nis": 
                  name => "$pname",
                  ensure => installed }
        service {"nis":
                name => $pname,
                ensure => running,
                enable => true,
                require => Package["nis"],
                status => "test -f /var/run/ypbind.pid"
        }

        file { "/etc/yp.conf":
                content => template("${this_profile}/etc/yp.conf"),
                require => Package["nis"],
                notify => Service["nis"]
        }

        file { "/etc/defaultdomain":
                content => "$network",
                require => Package["nis"],
                notify => Service["nis"]
        }

  $extraauthint = "nis"
       if $extraauth2 == "none"  {
           $changeset=[
            "set *[. = 'passwd']/service[1] files",
            "set *[. = 'passwd']/service[2] $extraauth",
            "set *[. = 'group']/service[1] files",
            "set *[. = 'group']/service[2] $extraauth",
            "set *[. = 'shadow']/service[1] files",
            "set *[. = 'shadow']/service[2] $extraauth",
             ]
      }
      else  { 
          $changeset=[
            "set *[. = 'passwd']/service[1] files",
            "set *[. = 'passwd']/service[2] $extraauth",
            "set *[. = 'passwd']/service[3] $extraauth2",
            "set *[. = 'group']/service[1] files",
            "set *[. = 'group']/service[2] $extraauth",
            "set *[. = 'group']/service[3] $extraauth2",
            "set *[. = 'shadow']/service[1] files",
            "set *[. = 'shadow']/service[2] $extraauth",
            "set *[. = 'shadow']/service[3] $extraauth2",
             ]


         }
         
      
            augeas{"nis":

       context   => '/files/etc/nsswitch.conf/',
      #This part changes options on an already existing line
      #This only works if the nsswitch.conf has passwd, group and shadow entries.  So you wont get the file created.
      changes   => $changeset,
#       notify    => Service['nis']
     }

   #TODO - copy in nsswitch if it doesnt exist

}
