#Really simlple facters for now, could look at something else to decide this, but surely this is a top down statement - thaou shalt authenticate against blah rather that what shall I auth against?
#might be good for dig _tcp._ldap or so
#Maybe this Nis module wasnt a great one to download
Facter.add("nis_servers") do
   setcode do
       "ppypman.physics.ox.ac.uk"
   end
end

Facter.add("nis_domain") do
   setcode do
        "npldecs"
   end
end
