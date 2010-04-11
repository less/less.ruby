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
    s.add_dependency('treetop', '>= 1.4.2')
    s.add_dependency('mutter', '>= 0.4.2')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'spec/rake/spectask'

Spec::Rake::SpecTask.new("spec") do |t|
  t.libs << 'lib' << 'spec'
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--color', '--format=specdoc']
end

task :test do
  Rake::Task['spec'].invoke
end

begin
  require 'lib/less'
  require 'benchmark'

  task :compile do
    abort "compiling isn't necessary anymore."
    puts "compiling #{LESS_GRAMMAR.split('/').last}..."
    File.open(LESS_PARSER, 'w') {|f| f.write Treetop::Compiler::GrammarCompiler.new.ruby_source(LESS_GRAMMAR) }
  end

  task :benchmark do
    less = File.read("spec/less/big.less")
    result = nil
    Benchmark.bmbm do |b|
      b.report("parse:  ") { result = Less::Engine.new(less).parse(false) }
      b.report("build:  ") { result = result.build(Less::Node::Element.new) }
      b.report("compile:") { result.to_css }
    end
  end
end

task :default => :spec
