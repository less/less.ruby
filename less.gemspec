# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{less}
  s.version = "0.8.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["cloudhead"]
  s.date = %q{2009-06-18}
  s.default_executable = %q{lessc}
  s.description = %q{LESS is leaner CSS}
  s.email = %q{alexis@cloudhead.net}
  s.executables = ["lessc"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "bin/lessc",
     "less.gemspec",
     "lib/less.rb",
     "lib/less/command.rb",
     "lib/less/engine.rb",
     "lib/less/tree.rb",
     "spec/command_spec.rb",
     "spec/css/less-0.8.5.css",
     "spec/css/less-0.8.6.css",
     "spec/css/less-0.8.7.css",
     "spec/css/less-0.8.8.css",
     "spec/css/less-0.9.0.css",
     "spec/engine_spec.rb",
     "spec/spec.css",
     "spec/spec.less",
     "spec/spec_helper.rb",
     "spec/tree_spec.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://www.lesscss.org}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{less}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{LESS compiler}
  s.test_files = [
    "spec/command_spec.rb",
     "spec/engine_spec.rb",
     "spec/spec_helper.rb",
     "spec/tree_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
