module ApplicationHelper

	def name(controller_name, action_name)
		hash = {}
		case controller_name 
		when "charts" 
			hash[:name] = "Weekly"
			hash[:time] = "Updates every Monday at 3:00 GMT"
			hash[:url] = nico_url(hash[:name].downcase, action_name)

		when "daily_charts"
			hash[:name] = "Daily"
			hash[:time] = "Rating for last 24 hours. Updates every hour."
			hash[:url] = nico_url(hash[:name].downcase, action_name)
		when "monthly_charts"
			hash[:name] = "Monthly"
			hash[:time] = "Rating for last month. Updates on the first day of every month at 2:00 GMT."
			hash[:url] = nico_url(hash[:name].downcase, action_name)
		when "total_charts"		
			hash[:name] = "Total"
			hash[:time] = "Rating for all time. Updates every day at at 1:00 GMT."
			hash[:url] = nico_url(hash[:name].downcase, action_name)
		end
		hash
	end

	def nico_url(name, act_name)
		case act_name
		when "favorites"
			"#{name}/fav"
		when "views"
			"#{name}/view"
		when "comments"
			"#{name}/res"
		when "mylist"
			"#{name}/mylist"
		end
	end
end
