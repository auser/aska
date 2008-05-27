require File.join(File.dirname(__FILE__), *%w[.. lib aska])

%w(test/spec).each do |library|
  begin
    require library
  rescue
    STDERR.puts "== Cannot run test without #{library}"
  end
end

Dir["#{File.dirname(__FILE__)}/helpers/**"].each {|a| require a}