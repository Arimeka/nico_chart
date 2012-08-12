module ChartsHelper
	def value_gain(action, name)
		result = case name
							when "views"
								action.view
							when "comments"
								action.comment
							when "mylist"
								action.mylist
							when "favorites"
								action.fav
					 	end			
	end

	def youtube?(action)
		result = case action.youtube_id
							when "empty"
								false
							else
								true
							end
	end
end
