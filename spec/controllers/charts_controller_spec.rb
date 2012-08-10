require 'spec_helper'

describe ChartsController do

  describe "GET 'get'" do
    it "returns http success" do
      get 'get'
      response.should be_success
    end
  end

  describe "GET 'view'" do
    it "returns http success" do
      get 'view'
      response.should be_success
    end
  end

end
