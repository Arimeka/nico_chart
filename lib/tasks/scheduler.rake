desc "This task is called by the Heroku scheduler add-on"
task :update_chart => :environment do
  if Time.now.strftime('%w%H').to_i == 003 # run every monday at 3:00 GMT
    Chart.get
  end
end

task :update_monthly_chart => :environment do
  if Time.now.strftime('%d%H').to_i == 0102 # run every first day of month at 2:00 GMT
    MonthlyChart.get
  end
end

task :update_daily_chart => :environment do
	DailyChart.get
end

task :check_daily_chart => :environment do
  DailyChart.check
end

task :update_total_chart => :environment do
	TotalChart.get
end

task :test_update => :environment do
	Chart.get
end