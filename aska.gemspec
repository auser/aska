Gem::Specification.new do |s|
  s.name = %q{aska}
  s.version = "0.0.9"

  s.required_rubygems_version = Gem::Requirement.new("= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ari Lerner"]
  s.cert_chain = nil
  s.date = %q{2008-10-31}
  s.description = %q{The basics of an expert system}
  s.email = %q{ari.lerner@citrusbyte.com}
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README", "lib", "lib/aska.rb", "lib/object.rb"]
  s.files = ["CHANGELOG", "LICENSE", "README", "Rakefile", "lib", "lib/aska.rb", "lib/object.rb", "spec", "spec/rules_spec.rb", "spec/spec_helper.rb", "aska.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://blog.citrusbyte.com}
  s.post_install_message = %q{
Aska - Expert system basics

See blog.citrusbyte.com for more details
*** Ari Lerner @ <ari.lerner@citrusbyte.com> ***

}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Aska", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{aska}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{The basics of an expert system}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
