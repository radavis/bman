require "sinatra"

def all_commands
  @all_commands ||= `apropos .* | col -b`
end

get "/" do
  "<pre>#{all_commands}</pre>"
end

get "/man/:command" do |command|
  command_info = `man #{command} | col -b`
  "<pre>#{command_info}</pre>"
end
