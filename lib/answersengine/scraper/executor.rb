require 'nokogiri'
module AnswersEngine
  module Scraper
    class Executor
      attr_accessor :filename, :gid, :job_id


      def exec_parser(save=false)
        raise "should be implemented in subclass"
      end

      def init_page()
        if job_id
          puts "getting Job Page"
          init_job_page
        else
          puts "getting Global Page"
          init_global_page()
        end

      end

      def init_job_page()
        client = Client::JobPage.new()
        job_page = client.find(job_id, gid)
        unless job_page.code == 200
          raise "Job #{job_id} or GID #{gid} not found. Aborting execution!"
        else
          job_page
        end

      end

      def parsing_update(options={})
        client = Client::JobPage.new()
        job_id = options.fetch(:job_id)
        gid = options.fetch(:gid)

        client.parsing_update(job_id, gid, options)
      end

      def seeding_update(options={})
        client = Client::Job.new()
        job_id = options.fetch(:job_id)

        client.seeding_update(job_id, options)
      end

      def init_global_page()
        client = Client::GlobalPage.new()
        client.find(gid)
      end

      def get_content(gid)
        client = Client::GlobalPage.new()
        content_json = client.find_content(gid)

        if content_json['available']
          signed_url = content_json['signed_url']
          Client::BackblazeContent.new.get_gunzipped_content(signed_url)
        else
          nil
        end
      end

      def get_failed_content(gid)
        client = Client::GlobalPage.new()
        content_json = client.find_failed_content(gid)

        if content_json['available']
          signed_url = content_json['signed_url']
          Client::BackblazeContent.new.get_gunzipped_content(signed_url)
        else
          nil
        end
      end

      def clean_backtrace(backtrace)
        i = backtrace.index{|x| x =~ /gems\/answersengine/i}
        if i.to_i < 1
          return []
        else
          return backtrace[0..(i-1)]
        end
      end

      def exposed_methods
        raise NotImplementedError.new('Specify methods exposed to isolated env')
      end

      # Create lambda to retrieve a variable or call instance method
      def var_or_proc vars, key
        myself = self # Avoid stack overflow
        return lambda{vars[key]} if vars.has_key?(key)
        lambda{|*args| myself.send(key, *args)}
      end

      def exposed_env vars
        keys = exposed_methods + vars.keys
        Hash[keys.map{|key|[key, var_or_proc(vars, key)]}]
      end

      def expose_to object, env
        metaclass = class << object; self; end
        env.each do |key, block|
          metaclass.send(:define_method, key, block)
        end
        object
      end

      # Create an isolated binding
      def isolated_binding vars
        create_top_object_script = '(
          lambda do
            object = Object.new
            metaclass = class << object
              define_method(:context_binding){binding}
            end
            object
          end
        ).call'
        object = TOPLEVEL_BINDING.eval(create_top_object_script)
        env = exposed_env(vars)
        expose_to object, env
        object.context_binding
      end
    end
  end
end
