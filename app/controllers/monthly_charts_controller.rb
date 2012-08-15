class MonthlyChartsController < ApplicationController
  def favorites
  	@chart = MonthlyChart.all(order: "fav DESC", limit: 100)
  end

  def views
  	@chart = MonthlyChart.all(order: "view DESC", limit: 100)
  end

  def comments
  	@chart = MonthlyChart.all(order: "comment DESC", limit: 100)
  end

  def mylist
  	@chart = MonthlyChart.all(order: "mylist DESC", limit: 100)
  end
end
