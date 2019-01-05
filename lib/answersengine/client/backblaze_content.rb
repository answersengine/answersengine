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
        # Zlib.gunzip(get_content(url))
        gunzip(get_content(url))
      end

      def gunzip(string)
        sio = StringIO.new(string)
        gz = Zlib::GzipReader.new(sio, encoding: Encoding::ASCII_8BIT)
        gz.read
      ensure
        gz.close if gz.respond_to?(:close)
      end
    end
  end
end
