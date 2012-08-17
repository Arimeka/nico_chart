class TotalChartsController < ApplicationController
  def views
  	@chart = TotalChart.all(order: "view DESC", limit: 100)
  end

  def comments
  	@chart = TotalChart.all(order: "comment DESC", limit: 100)
  end

  def mylist
  	@chart = TotalChart.all(order: "mylist DESC", limit: 100)
  end

  def favorites
  	@chart = TotalChart.all(order: "fav DESC", limit: 100)
  end
end
