require 'sinatra/base'

class FakeYouTube < Sinatra::Base
  get '/discovery/v1/apis/youtube/v3/rest' do
    json_response 200, 'dsicovery.json'
  end

  get '/youtube/v3/search' do
    json_response 200, 'search.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
