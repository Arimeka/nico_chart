class TotalChartsController < ApplicationController
  def views
  	@chart = TotalChart.all_caching("view DESC", 100)
  end

  def comments
  	@chart = TotalChart.all_caching("comment DESC", 100)
  end

  def mylist
  	@chart = TotalChart.all_caching("mylist DESC", 100)
  end

  def favorites
  	@chart = TotalChart.all_caching("fav DESC", 100)
  end
end
