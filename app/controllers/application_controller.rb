class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper

  def refind
    session[:return_to] ||= request.referer
    if params[:contr] == "daily_charts"      
      @video = DailyChart.find_by_nico_id(params[:id])
      DailyChart.expire_self_all_cache
    elsif params[:contr] == "monthly_charts"
      @video = MonthlyChart.find_by_nico_id(params[:id])
      MonthlyChart.expire_self_all_cache
    elsif params[:contr] == "total_charts"
      @video = TotalChart.find_by_nico_id(params[:id])
      TotalChart.expire_self_all_cache
    else
      @video = Chart.find_by_nico_id(params[:id])
      Chart.expire_self_all_cache
    end
    reload(@video)
    redirect_to session.delete(:return_to)
  end
end
