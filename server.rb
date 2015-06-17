require "sinatra"
require "./lib/unix_command"

require "pry"

get "/" do
  redirect to("/unix_commands")
end

get "/unix_commands" do
  params[:page] ||= 1
  page = params[:page].to_i
  per_page = 30
  @unix_commands = UnixCommand.all[((page - 1) * per_page)...(page * per_page)]
  erb :index
end

get "/unix_commands/:command" do |command|
  unix_command = UnixCommand.find_by(name: command)
  "<pre>#{unix_command.man_page}</pre>"
end
