module AnswersEngine
  module Client
    class GlobalPage < AnswersEngine::Client::Base
      def find(gid)
        self.class.get("/global_pages/#{gid}", @options)
      end

      def refetch(gid)
        self.class.put("/global_pages/#{gid}/refetch", @options)
      end

      def find_content(gid)
        self.class.get("/global_pages/#{gid}/content", @options)
      end

      def find_failed_content(gid)
        self.class.get("/global_pages/#{gid}/failed_content", @options)
      end
    end
  end
end

