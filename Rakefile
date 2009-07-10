begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name        = "less"
    s.authors     = ["cloudhead"]
    s.email       = "self@cloudhead.net"
    s.summary     = "LESS compiler"
    s.homepage    = "http://www.lesscss.org"
    s.description = "LESS is leaner CSS"
    s.rubyforge_project = 'less'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

# rubyforge
begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do

    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]

    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )
        options << '--line-numbers' << '--inline-source'
        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/the-perfect-gem/"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end

begin
  require 'spec/rake/spectask'

  Spec::Rake::SpecTask.new("spec") do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ['--color', '--format=specdoc']
  end

  task :test do
    Rake::Task['spec'].invoke
  end

  Spec::Rake::SpecTask.new("rcov_spec") do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ['--color']
    t.rcov = true
    t.rcov_opts = ['--exclude', '^spec,/gems/']
  end
end

begin
  require 'lib/less'
  
  task :compile do
    puts "compiling #{Less::GRAMMAR.split('/').last}..."
    File.open(Less::PARSER, 'w') {|f| f.write Treetop::Compiler::GrammarCompiler.new.ruby_source(Less::GRAMMAR) }
  end
  
  task :benchmark do
    print "benchmarking... "
    less = File.read("spec/less/big-1.0.less")
    start = Time.now.to_f
    Less::Engine.new(less).parse
    total = Time.now.to_f - start
    puts "#{total}s"
  end
end

