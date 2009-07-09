# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{less}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["cloudhead"]
  s.date = %q{2009-07-08}
  s.default_executable = %q{lessc}
  s.description = %q{LESS is leaner CSS}
  s.email = %q{self@cloudhead.net}
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
     "lib/less/engine/builder.rb",
     "lib/less/engine/less.tt",
     "lib/less/engine/nodes.rb",
     "lib/less/engine/nodes/element.rb",
     "lib/less/engine/nodes/entity.rb",
     "lib/less/engine/nodes/function.rb",
     "lib/less/engine/nodes/literal.rb",
     "lib/less/engine/nodes/property.rb",
     "lib/less/engine/nodes/selector.rb",
     "lib/less/engine/parser.rb",
     "spec/command_spec.rb",
     "spec/css/accessors-1.0.css",
     "spec/css/big-1.0.css",
     "spec/css/comments-1.0.css",
     "spec/css/css-1.0.css",
     "spec/css/functions-1.0.css",
     "spec/css/import-1.0.css",
     "spec/css/mixins-1.0.css",
     "spec/css/operations-1.0.css",
     "spec/css/rulesets-1.0.css",
     "spec/css/scope-1.0.css",
     "spec/css/strings-1.0.css",
     "spec/css/variables-1.0.css",
     "spec/css/whitespace-1.0.css",
     "spec/engine_spec.rb",
     "spec/less/accessors-1.0.less",
     "spec/less/big-1.0.less",
     "spec/less/colors-1.0.less",
     "spec/less/comments-1.0.less",
     "spec/less/css-1.0.less",
     "spec/less/exceptions/mixed-units-error.less",
     "spec/less/exceptions/name-error-1.0.less",
     "spec/less/exceptions/syntax-error-1.0.less",
     "spec/less/functions-1.0.less",
     "spec/less/import-1.0.less",
     "spec/less/import/import-test-a.less",
     "spec/less/import/import-test-b.less",
     "spec/less/import/import-test-c.less",
     "spec/less/mixins-1.0.less",
     "spec/less/operations-1.0.less",
     "spec/less/rulesets-1.0.less",
     "spec/less/scope-1.0.less",
     "spec/less/strings-1.0.less",
     "spec/less/variables-1.0.less",
     "spec/less/whitespace-1.0.less",
     "spec/spec.css",
     "spec/spec.less",
     "spec/spec_helper.rb"
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
     "spec/spec_helper.rb"
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
