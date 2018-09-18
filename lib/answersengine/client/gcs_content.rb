require 'httparty'

module AnswersEngine
  module Client
    class GCSContent
      include HTTParty    
      
      def get_content(url)
        self.class.get(url)
      end
    end
  end
end
