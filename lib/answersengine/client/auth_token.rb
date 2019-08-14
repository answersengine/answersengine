module AnswersEngine
  module Client
    class AuthToken < AnswersEngine::Client::Base

      def find(token)
        self.class.get("/auth_tokens/#{token}", @options)
      end

      def all(opts={})
        params = @options.merge(opts)
        self.class.get("/auth_tokens", params)
      end

      def create(role, description, opts={})
        body = {
            role: role,
            description: description}

        params = @options.merge({body: body.to_json})
        self.class.post("/auth_tokens", params)
      end

      def create_on_account(account_id, role, description)
        body = {
            role: role,
            description: description}

        params = @options.merge({body: body.to_json})
        self.class.post("/accounts/#{account_id}/auth_tokens", params)
      end

      def update(token, role, description="", opts={})
        body = {}

        body[:role] = role
        body[:description] = description if description.present?
        params = @options.merge({body: body.to_json})

        self.class.put("/auth_tokens/#{token}", params)
      end

      def delete(token, opts={})
        body = {}
        params = @options.merge({body: body.to_json})

        self.class.delete("/auth_tokens/#{token}", params)
      end
    end
  end
end
