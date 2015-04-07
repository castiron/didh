# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'dhdebates'
set :repo_url, 'git@github.com:castiron/didh.git'
set :deploy_to, '/home/dhdebates/dhdebates'
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_files, ["config/secrets.yml"]
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo stop #{fetch(:application)} || true"
      execute "sudo start #{fetch(:application)}"
    end
  end

  desc 'Import Texts'
  task :import_texts do
    on roles(:app) do
      within release_path do
        execute :rake, 'texts:import'
      end
    end
  end

  before 'deploy:published', :import_texts
  after :publishing, :restart

end
