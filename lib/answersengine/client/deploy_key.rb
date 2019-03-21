module AnswersEngine
  module Client
    class DeployKey < AnswersEngine::Client::Base

      def find(opts={})
        self.class.get("/deploy_key", @options)
      end

      def create(opts={})
        self.class.post("/deploy_key", @options)
      end

      def delete(opts={})
        self.class.delete("/deploy_key", @options)
      end
    end
  end
end

