class DailyChartsController < ApplicationController
  def favorites
  	@chart = DailyChart.all_caching("fav DESC", 100)
  end

  def views
  	@chart = DailyChart.all_caching("view DESC", 100)
  end

  def comments
  	@chart = DailyChart.all_caching("comment DESC", 100)
  end

  def mylist
  	@chart = DailyChart.all_caching("mylist DESC", 100)
  end
end
