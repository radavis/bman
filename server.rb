require "active_support/core_ext/string"
require "sinatra"
require "./lib/unix_command"

def pagination
  @page = params['page']
  @page ||= 1
  @page = @page.to_i

  if @page <= 1
    @prev_path = '#'
  else
    @prev_path = "/unix_commands?page=#{ @page - 1 }"
  end

  @next_path = "/unix_commands?page=#{ @page + 1 }"
end

get "/" do
  redirect to("/unix_commands")
end

get "/random" do
  @unix_command = UnixCommand.sample
  erb :show
end

get "/search" do
  @unix_command = UnixCommand.find_by(name: params[:q])
  if @unix_command.present?
    erb :show
  else
    erb "<pre>Not Found</pre>"
  end
end

get "/unix_commands" do
  pagination
  per_page = 50
  @unix_commands = UnixCommand.all[((@page - 1) * per_page)...(@page * per_page)]
  erb :index
end

get "/unix_commands/:command" do |command|
  @unix_command = UnixCommand.find_by(name: command)
  erb :show
end
