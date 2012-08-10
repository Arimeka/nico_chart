require 'spec_helper'

describe ChartController do

  describe "GET 'nico_id:string'" do
    it "returns http success" do
      get 'nico_id:string'
      response.should be_success
    end
  end

  describe "GET 'youtube_id:string'" do
    it "returns http success" do
      get 'youtube_id:string'
      response.should be_success
    end
  end

  describe "GET 'view:integer'" do
    it "returns http success" do
      get 'view:integer'
      response.should be_success
    end
  end

  describe "GET 'comment:integer'" do
    it "returns http success" do
      get 'comment:integer'
      response.should be_success
    end
  end

  describe "GET 'mylist:integer'" do
    it "returns http success" do
      get 'mylist:integer'
      response.should be_success
    end
  end

  describe "GET 'fav:integer'" do
    it "returns http success" do
      get 'fav:integer'
      response.should be_success
    end
  end

end
