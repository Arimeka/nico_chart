class MonthlyChartsController < ApplicationController
  def favorites
  	@chart = MonthlyChart.all_caching("fav DESC", 100)
  end

  def views
  	@chart = MonthlyChart.all_caching("view DESC", 100)
  end

  def comments
  	@chart = MonthlyChart.all_caching("comment DESC", 100)
  end

  def mylist
  	@chart = MonthlyChart.all_caching("mylist DESC", 100)
  end
end
