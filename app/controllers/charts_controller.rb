class ChartsController < ApplicationController
  def views
    @chart = Chart.all_caching("view DESC", 100)
  end

  def comments
    @chart = Chart.all_caching("comment DESC", 100)
  end

  def mylist
    @chart = Chart.all_caching("mylist DESC", 100)
  end

  def favorites     
    @chart = Chart.all_caching("fav DESC", 100)    
  end
end
