# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'nico_chart'
set :repo_url, 'git@github.com:Arimeka/nico_chart.git'

set :scm_verbose, true
set :default_stage, 'production'
set :ssh_options, {
  user: 'nicochart',
  forward_agent: true,
  keys: %w(~/.ssh/id_rsa)
}

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :linked_files, %w{config/database.yml config/google_api.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache vendor/bundle}

namespace :assets do
  desc 'Local assets compilation'
  task :precompile do
    run_locally do
      execute <<-CMD
        rake assets:clean
        nice -n 19 rake assets:precompile RAILS_ENV=#{fetch(:rails_env)}
        cd public
        tar -zcf assets.tar.gz assets
      CMD
    end
  end

  desc 'Upload assets to server'
  task :uploads do
    on roles(:app) do
      upload! "public/assets.tar.gz", "#{fetch(:release_path)}/public", via: :scp, recursive: true
      execute "cd #{fetch(:release_path)}/public && tar -xf assets.tar.gz && rm assets.tar.gz"
    end
    run_locally do
      execute "cd public && rm -rf assets*"
    end
  end
end

namespace :golang do
  desc 'Compiling golang application'
  task :compile do
    run_locally do
      execute  <<-CMD
        gvm use 1.4.2
        go build nicochart-go/main.go
      CMD
    end
  end

  desc 'Upload compiled application to server'
  task :upload do
    on roles(:app) do
      upload! 'nicochart-go/main', "#{fetch(:release_path)}/nicochart-go", via: :scp
    end
    run_locally do
      execute 'cd nicochart-go && rm main'
    end
  end
end

namespace :deploy do
  before  'deploy',             'deploy:check'
  before  'deploy:check',       'assets:precompile'
  before  'assets:precompile',  'golang:compile'
  after   'deploy:updated',     'assets:uploads'
  after   'assets:uploads',     'golang:upload'
  after   'deploy:cleanup',     'deploy:restart'
  after   'deploy:rollback',    'deploy:restart'
  before  'deploy:restart',     'deploy:load_eye'

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      execute 'eye restart #{application}'
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app) do
      execute 'eye restart #{application}'
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      execute 'eye stop #{application}'
    end
  end

  task :load_eye do
    on roles(:app) do
      execute "eye load #{fetch(:release_path)}/config/eye.conf.#{fetch(:rails_env)}.rb"
    end
  end
end
