module AnswersEngine
  module Plugin
    module ContextExposer
      def self.exposed_methods
        raise NotImplementedError.new('Specify methods exposed to isolated env')
      end

      def exposed_methods
        self.class.exposed_methods
      end

      # Create lambda to retrieve a variable or call instance method
      def var_or_proc vars, key
        myself = self # Avoid stack overflow
        return lambda{vars[key]} if vars.has_key?(key)
        lambda{|*args| myself.send(key, *args)}
      end

      def exposed_env vars
        keys = exposed_methods + vars.keys
        Hash[keys.uniq.map{|key|[key, var_or_proc(vars, key)]}]
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
