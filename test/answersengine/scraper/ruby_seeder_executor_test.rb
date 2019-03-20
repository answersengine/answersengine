require 'test_helper'

describe 'ruby_seeder_executor' do
  describe 'unit test' do
  end

  describe 'integration test'do
    before do
      @seeder_script = Tempfile.new(['seeder_script', '.rb'], encoding: 'UTF-8')
      @seeder_script.write "
        pages << {'gid' => '123', 'page' => 'Success!'}
        outputs << {'gid' => '123', 'output' => 'Success!'}
        find_output 'collectionA', {'_id' => 'outputA'}
        find_outputs 'collectionB', {'_id' => 'outputB'}
      "
      @seeder_script.flush
      @seeder_script.close

      @executor = AnswersEngine::Scraper::RubySeederExecutor.new({
        filename: @seeder_script.path,
        job_id: nil
      })
      # Mock executor for test results
      class << @executor
        define_method(:__mock_set_test_result){|result|@__mock_test_result = result}
        define_method(:__mock_test_result){@__mock_test_result}
        define_method(:seeding_update) do |opts|
          @__mock_test_result ||= []
          @__mock_test_result << opts.merge!(
            find_output_args: @__mock_find_output_args,
            find_outputs_args: @__mock_find_outputs_args
          )
          @__mock_find_output_args = nil
          @__mock_find_outputs_args = nil
          object = Object.new
          class << object
            define_method(:code){200}
          end
          object
        end
        define_method(:find_output){|*args|@__mock_find_output_args = args}
        define_method(:find_outputs){|*args|@__mock_find_outputs_args = args}
      end
    end

    after do
      @seeder_script.unlink
    end

    it "should save outputs from script" do
      @executor.exec_seeder true
      data = @executor.__mock_test_result
      expected = [{'gid' => '123', 'output' => 'Success!'}]
      assert_equal expected, data[1][:outputs]
    end

    it "should save pages from script" do
      @executor.exec_seeder true
      data = @executor.__mock_test_result
      expected = [{'gid' => '123', 'page' => 'Success!'}]
      assert_equal expected, data[1][:pages]
    end

    it "should execute find_output from script" do
      @executor.exec_seeder true
      data = @executor.__mock_test_result
      expected = ['collectionA', {'_id' => 'outputA'}]
      assert_equal expected, data[1][:find_output_args]
    end

    it "should execute find_outputs from script" do
      @executor.exec_seeder true
      data = @executor.__mock_test_result
      expected = ['collectionB', {'_id' => 'outputB'}]
      assert_equal expected, data[1][:find_outputs_args]
    end

    it "should eval without class context" do
      library_script = script = data = nil
      begin
        # Create test library and script
        library_script = Tempfile.new(['library_script', '.rb'], encoding: 'UTF-8')
        library_script.write '
          class Scraper
            def self.hello_world
              "Hello world"
            end
          end
        '
        library_script.flush
        library_script.close
        script = Tempfile.new(['seeder_script', '.rb'], encoding: 'UTF-8')
        script.write "
          require '#{library_script.path.scan(/^(.+?)\.rb$/).first.first}'

          begin
            __mock_set_test_result Scraper.hello_world
          rescue Exception => e
            __mock_set_test_result \"\#{e.message}\\n\#{e.backtrace}\"
          end
        "
        script.flush
        script.close

        # Create executor object and mock for test results
        executor = AnswersEngine::Scraper::RubySeederExecutor.new({
          filename: script.path,
          gid: '123',
          job_id: nil,
          page_vars: nil
        })
        class << executor
          define_method(:__mock_set_test_result){|result|@__mock_test_result = result}
          define_method(:__mock_test_result){@__mock_test_result}
          define_method(:exposed_methods){[:__mock_set_test_result].freeze}
        end

        # Test stuff
        executor.__mock_set_test_result 'FAIL'
        executor.exec_seeder false
        data = executor.__mock_test_result
      ensure
        library_script.unlink unless library_script.nil?
        script.unlink unless script.nil?
      end
      assert_equal 'Hello world', data
    end
  end
end
