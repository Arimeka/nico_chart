desc "This task is called by the Heroku scheduler add-on"
task :update_chart => :environment do
  if Time.now.strftime('%w%H%M').to_i == 00400 # run every sunday at 4:00 GMT
    Chart.get
  end
end