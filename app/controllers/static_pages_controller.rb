class StaticPagesController < ApplicationController
	caches_page :home
	
  def home
  end
end
