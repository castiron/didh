rails_env = ENV['RAILS_ENV'] || 'production'

if ENV['BOXEN_SOCKET_DIR']
  socket = "#{ENV['BOXEN_SOCKET_DIR']}/didh"
  processes = 3
else
  socket = "#{ENV['UNICORN_SOCKET_PATH']}"
  processes = 6
end

worker_processes processes
listen socket, :backlog => 1024

if rails_env == 'production'
  preload_app true
end

timeout 600
if ENV['UNICORN_LOG_DIR']
  stderr_path = "#{ENV['UNICORN_LOG_DIR']}/unicorn.log"
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end