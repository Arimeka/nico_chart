desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Time.now.strftime('%w%H%M').to_i == 00400 # run every sunday at 4:00 GMT
    Chart.get
  end
end