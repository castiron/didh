# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'dhdebates'
set :repo_url, 'git@github.com:castiron/didh.git'
set :deploy_to, -> { "#{fetch(:deploy_dir)}" }
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_files, ["config/secrets.yml"]
set :keep_releases, 5
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo stop #{fetch(:application)} || true"
      execute "sudo start #{fetch(:application)}"
    end
  end

  desc 'Import Texts'
  task :texts do
    on roles(:app) do
      within release_path do
        execute :rake, 'texts:import'
      end
    end
  end

  after :publishing, :restart
end

namespace :setup do
  desc "Copy secrets"
  task :secrets do
    on roles(:all) do |host|
      upload! "./config/secrets.yml", "#{shared_path}/config/secrets.yml"
    end
  end
end

namespace :info do
  task :new_commits do
    on roles(:app) do
      comparator = 'origin/master'
      current = capture "cat #{current_path}/REVISION"
      command = "git show-branch #{current} #{comparator}"
      puts "\nREMOTE is currently at #{current}"
      puts "#{command}\n\n"
      system command
    end
  end

  task :default => 'info:new_commits'
end

task :info => 'info:default'