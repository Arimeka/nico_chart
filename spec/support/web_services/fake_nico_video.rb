require 'sinatra/base'

class FakeNicoVideo < Sinatra::Base
  get '/ranking/fav/:type/vocaloid' do
    xml_response 200, 'daily.xml'
  end

  private

  def xml_response(response_code, file_name)
    content_type :xml
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
