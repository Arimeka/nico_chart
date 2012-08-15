require 'spec_helper'

describe MonthlyChartsController do

  describe "GET 'views'" do
    it "returns http success" do
      get 'views'
      response.should be_success
    end
  end

  describe "GET 'comments'" do
    it "returns http success" do
      get 'comments'
      response.should be_success
    end
  end

  describe "GET 'mylist'" do
    it "returns http success" do
      get 'mylist'
      response.should be_success
    end
  end

  describe "GET 'favorites'" do
    it "returns http success" do
      get 'favorites'
      response.should be_success
    end
  end

end
