Gem::Specification.new do |s|
   s.name        = "less"
   s.version     = "0.1"
   s.date        = Time.today.strftime("%Y-%m-%d")
   s.authors     = ["cloudhead"]
   s.email       = "alexis@cloudhead.net"
   s.summary     = "LESS compiler"
   s.homepage    = "http://www.lesscss.org"
   s.description = "Compiles LESS files into CSS"
   s.files       = [ 
     "README", 
     "bin/lessc", 
     "lib/less.rb", 
     "lib/less/command.rb", 
     "lib/less/engine.rb", 
     "lib/less/tree.rb"
   ]
   
   s.bindir             = "bin"
   s.default_executable = "lessc"
   s.executables        = "lessc"
end