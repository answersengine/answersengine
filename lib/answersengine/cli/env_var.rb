module AnswersEngine
  class CLI < Thor
    class EnvVar < Thor
      desc "list", "List environment variables on the account"
      
      long_desc <<-LONGDESC
        List all environment variables on the account.
      LONGDESC
      option :page, :aliases => :p, type: :numeric, desc: 'Get the next set of records by page.'
      option :per_page, :aliases => :P, type: :numeric, desc: 'Number of records per page. Max 500 per page.'
      def list
        client = Client::EnvVar.new(options)
        puts "#{client.all}"
      end

      desc "set <name> <value>", "Set an environment var on the account"
      long_desc <<-LONGDESC
          Creates an environment variable\x5
          <name>: Var name can only consist of alphabets, numbers, underscores. Name must be unique to your account, otherwise it will be overwritten.\x5
          <value>: Value of variable.\x5
          LONGDESC
      option :secret, type: :boolean, desc: 'Set true to make it decrypt the value. Default: false' 
      def set(name, value)
        # puts "options #{options}"
        client = Client::EnvVar.new(options)
        puts "#{client.set(name, value, options)}"
      end

      desc "show <name>", "Show an environment variable on the account"
      def show(name)
        client = Client::EnvVar.new(options)
        puts "#{client.find(name)}"
      end

      desc "unset <name>", "Deletes an environment variable on the account"
      def unset(name)
        client = Client::EnvVar.new(options)
        puts "#{client.unset(name)}"
      end


      


    end
  end

end
