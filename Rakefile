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
    s.add_dependency('mutter', '>= 0.3.7')
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new
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
    #require 'profile'
    puts "benchmarking... "
    less, tree = File.read("spec/less/big.less"), nil
    
    parse = Benchmark.measure do
      tree = Less::Engine.new(less).parse(false)
    end.total.round(2)
    
    build = Benchmark.measure do
      tree.build(Less::Node::Element.new)
    end.total.round(2)
    
    puts "parse: #{parse}s\nbuild: #{build}s"
    puts "------------"
    puts "total: #{parse + build}s"
  end
end

task :default => :spec
