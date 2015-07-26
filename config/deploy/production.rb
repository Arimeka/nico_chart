set :deploy_to, '/var/www/vocaloid.anifag.com'
set :rails_env, 'production'

role :app, %w{vocaloid.anifag.com}, primary: true
role :db,  %w{vocaloid.anifag.com}, primary: true
