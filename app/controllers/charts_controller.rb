class ChartsController < ApplicationController
  def views
    @chart = Chart.all(order: "view DESC", limit: 100)
  end

  def comments
    @chart = Chart.all(order: "comment DESC", limit: 100)
  end

  def mylist
    @chart = Chart.all(order: "mylist DESC", limit: 100)
  end

  def favorites
    @chart = Chart.all(order: "fav DESC", limit: 100)
  end
end
