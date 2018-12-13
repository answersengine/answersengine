require 'zlib'
require 'httparty'

module AnswersEngine
  module Client
    class BackblazeContent
      include HTTParty    
      
      def get_content(url)
        self.class.get(url, format: :plain)
      end

      def get_gunzipped_content(url)
        Zlib.gunzip(get_content(url))
      end
    end
  end
end
