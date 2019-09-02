module AnswersEngine
  module Client
    class EnvVar < AnswersEngine::Client::Base

      def find(name)
        self.class.get("/env_vars/#{name}", @options)
      end

      def all(opts={})
        params = @options.merge opts
        self.class.get("/env_vars", params)
      end

      def set(name, value, opts={})
        body = {}
        body[:value] = value
        body[:secret] = opts[:secret] if opts[:secret]
        params = @options.merge({body: body.to_json})
        self.class.put("/env_vars/#{name}", params)
      end

      def unset(name, opts={})
        params = @options.merge(opts)
        self.class.delete("/env_vars/#{name}", params)
      end
    end
  end
end
