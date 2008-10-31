begin
  require 'echoe'
  Echoe.new("aska") do |p|
    p.author = "Ari Lerner"
    p.email = "ari.lerner@citrusbyte.com"
    p.summary = "The basics of an expert system"
    p.url = "http://blog.citrusbyte.com"
    p.dependencies = []
    p.version = "0.0.8"
    p.install_message =<<-EOM

      Aska - Expert system basics
      
      See blog.citrusbyte.com for more details
      *** Ari Lerner @ <ari.lerner@citrusbyte.com> ***

    EOM
    p.include_rakefile = true
  end  
rescue Exception => e
  
end

namespace(:pkg) do
  ## Rake task to create/update a .manifest file in your project, as well as update *.gemspec
  desc %{Update ".manifest" with the latest list of project filenames. Respect\
  .gitignore by excluding everything that git ignores. Update `files` and\
  `test_files` arrays in "*.gemspec" file if it's present.}
  task :manifest do
    list = Dir['**/*'].sort
    spec_file = Dir['*.gemspec'].first
    list -= [spec_file] if spec_file

    File.read('.gitignore').each_line do |glob|
      glob = glob.chomp.sub(/^\//, '')
      list -= Dir[glob]
      list -= Dir["#{glob}/**/*"] if File.directory?(glob) and !File.symlink?(glob)
      puts "excluding #{glob}"
    end

    if spec_file
      spec = File.read spec_file
      spec.gsub! /^(\s* s.(test_)?files \s* = \s* )( \[ [^\]]* \] | %w\( [^)]* \) )/mx do
        assignment = $1
        bunch = $2 ? list.grep(/^test\//) : list
        '%s%%w(%s)' % [assignment, bunch.join(' ')]
      end

      File.open(spec_file,   'w') {|f| f << spec }
    end
    File.open('Manifest', 'w') {|f| f << list.join("\n") }
  end
  desc "Build gemspec for github"
  task :gemspec => :manifest do
    require "yaml"
    `rake manifest gem`
    data = YAML.load(open("aska.gemspec").read).to_ruby
    File.open("aska.gemspec", "w+") {|f| f << data }
  end
  desc "Update gemspec with the time"
  task :gemspec_update => :gemspec do
  end
  desc "Get ready to release the gem"
  task :prerelease => :gemspec_update do
    `git add .`
    `git ci -a -m "Updated gemspec for github"`
  end
  desc "Release them gem to the gem server"
  task :release => :prerelease do
    `git push origin master`
  end
end