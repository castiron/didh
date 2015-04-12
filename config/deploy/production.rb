set :branch, "master"
set :server_name, "dhdebates-webserver.ciclabs.com"

set :stage, :production
set :rails_env, :production

role :app, %w{dhdebates@dhdebates-webserver.ciclabs.com}
role :web, %w{dhdebates@dhdebates-webserver.ciclabs.com}
role :db,  %w{dhdebates@dhdebates-webserver.ciclabs.com}

set :deploy_to, "~/#{fetch(:application)}"

