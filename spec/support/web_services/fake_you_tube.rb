require 'sinatra/base'

class FakeYouTube < Sinatra::Base
  get '/feeds/api/videos' do
    xml_response 200, 'search.xml'
  end

  private

  def xml_response(response_code, file_name)
    content_type :xml
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
