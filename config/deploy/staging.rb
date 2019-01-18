set :branch, "master"
set :server_name, "dhdebates.cicnode.com"
set :deploy_dir, "/home/dhdebates/deploy"
set :stage, :production
set :rails_env, :production

role :app, %w{dhdebates@dhdebates.cicnode.com}
role :web, %w{dhdebates@dhdebates.cicnode.com}
role :db, %w{dhdebates@dhdebates.cicnode.com}

