set :branch, "master"
set :server_name, "dhdebates.cic-stg.com"

set :stage, :production
set :rails_env, :production

role :app, %w{dhdebates@dhdebates.cic-stg.com}
role :web, %w{dhdebates@dhdebates.cic-stg.com}
role :db, %w{dhdebates@dhdebates.cic-stg.com}

