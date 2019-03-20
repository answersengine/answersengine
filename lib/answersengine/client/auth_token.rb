module AnswersEngine
  module Client
    class AuthToken < AnswersEngine::Client::Base

      def find(token)
        self.class.get("/auth_tokens/#{token}", @options)
      end

      def all(opts={})
        self.class.get("/auth_tokens", @options)
      end

      def create(role, description, opts={})
        body = {
            role: role,
            description: description}

        @options.merge!({body: body.to_json})
        self.class.post("/auth_tokens", @options)
      end

      def create_on_account(account_id, role, description)
        body = {
            role: role,
            description: description}

        @options.merge!({body: body.to_json})
        self.class.post("/accounts/#{account_id}/auth_tokens", @options)
      end

      def update(token, role, description="", opts={})
        body = {}

        body[:role] = role
        body[:description] = description if description.present?
        @options.merge!({body: body.to_json})

        self.class.put("/auth_tokens/#{token}", @options)
      end

      def delete(token, opts={})
        body = {}
        @options.merge!({body: body.to_json})

        self.class.delete("/auth_tokens/#{token}", @options)
      end
    end
  end
end

