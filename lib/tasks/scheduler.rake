desc "This task is called by the Heroku scheduler add-on"
task :update_chart => :environment do
  if Time.now.strftime('%w%H').to_i == 003 # run every sunday at 3:00 GMT
    Chart.get
  end
end

task :update_daily_chart => :environment do
	DailyChart.get
end

task :test_update => :environment do
	Chart.get
end