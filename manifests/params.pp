class nis::params (

          $nis_domain = hiera("nis::params::nis_domain", "npldecs"),
          #files is always first
          #pass extraauth
          $servers = hiera_array("nis::params::servers", ['ppypman'] ),
          #ypbind listens on a specific port.  We want to use iptables,
          $ypbindport = hiera("nis::params::ypbindport", 883 ),
)
{}
