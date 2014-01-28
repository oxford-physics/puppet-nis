class nis::params (

          $nis_domain = hiera("nis::params::nis_domain", "npldecs"),
          #files is always first
          #pass extraauth
          $extraauth = hiera("nis::params::extraauth",  "nis" ),
          $extraauth2 = hiera("nis::params::extraauth2",  "none" ),
          $servers = hiera_array("nis::params::servers", ['ppypman'] ),
          #ypbind listens on a specific port.  We want to use iptables,
          $ypbindport = hiera("nis::params::ypbindport", 883 ),
)
{}
