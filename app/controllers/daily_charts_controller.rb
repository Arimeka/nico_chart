class DailyChartsController < ApplicationController
  def favorites
  	@chart = DailyChart.all(order: "fav DESC", limit: 100)
  end

  def views
  	@chart = DailyChart.all(order: "view DESC", limit: 100)
  end

  def comments
  	@chart = DailyChart.all(order: "comment DESC", limit: 100)
  end

  def mylist
  	@chart = DailyChart.all(order: "mylist DESC", limit: 100)
  end
end
