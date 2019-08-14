module AnswersEngine
  module Client
    class DeployKey < AnswersEngine::Client::Base

      def find(opts={})
        params = @options.merge(opts)
        self.class.get("/deploy_key", params)
      end

      def create(opts={})
        params = @options.merge(opts)
        self.class.post("/deploy_key", params)
      end

      def delete(opts={})
        params = @options.merge(opts)
        self.class.delete("/deploy_key", params)
      end
    end
  end
end
