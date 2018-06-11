#!/usr/bin/env puma

daemonize false
pidfile "tmp/pids/puma.pid"
state_path "tmp/pids/puma.state"
threads 0, 16
tag "didh"
preload_app!
rackup      DefaultRackup
environment ENV["RAILS_ENV"] || "development"
name = "didh"

if ENV["RAILS_SERVER_SOCKET_PATH"]
  socket_dir = "unix://#{ENV['RAILS_SERVER_SOCKET_DIR']}"
  socket_path = "unix://#{ENV['RAILS_SERVER_SOCKET_PATH']}"  
else
  dir = File.join(Dir.pwd, "tmp", "sockets")
  path = File.join(dir, name)
  socket_dir = "unix://#{dir}"
  socket_path = "unix://#{path}"
end

bind socket_path

activate_control_app "#{socket_dir}/#{name}-control"
on_worker_boot do
  ActiveRecord::Base.establish_connection
end
