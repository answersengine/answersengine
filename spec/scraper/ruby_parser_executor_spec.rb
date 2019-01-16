require 'tempfile'

RSpec.describe AnswersEngine::Scraper::RubyParserExecutor do
  before(:all) do
    @parser_script = Tempfile.new(['parser_script', '.rb'], encoding: 'UTF-8')
    @parser_script.write "
      outputs << {'gid' => page['gid'], 'output' => 'Success!'}
      pages << {'gid' => page['gid'], 'page' => 'Success!'}
      find_output 'collectionA', {'_id' => 'outputA'}
      find_outputs 'collectionB', {'_id' => 'outputB'}
    "
    @parser_script.flush
    @parser_script.close
  end

  after(:all) do
    @parser_script.unlink
  end

  before(:each) do
    @executor = AnswersEngine::Scraper::RubyParserExecutor.new({
      filename: @parser_script.path,
      gid: '123',
      job_id: nil,
      page_vars: nil
    })
    # Mock executor for test results
    class << @executor
      define_method(:__mock_set_test_result){|result|@__mock_test_result = result}
      define_method(:__mock_test_result){@__mock_test_result}
      define_method(:parsing_update) do |opts|
        @__mock_test_result = opts.merge!(
          find_output_args: @__mock_find_output_args,
          find_outputs_args: @__mock_find_outputs_args
        )
        object = Object.new
        class << object
          define_method(:code){200}
        end
        object
      end
      define_method(:init_page){{'gid' => '123'}}
      define_method(:find_output){|*args|@__mock_find_output_args = args}
      define_method(:find_outputs){|*args|@__mock_find_outputs_args = args}
    end
  end

  it "should save outputs from script" do
    @executor.eval_parser_script true
    result = @executor.__mock_test_result
    expect(result[:outputs]).to eql [{'gid' => '123', 'output' => 'Success!'}]
  end

  it "should save pages from script" do
    @executor.eval_parser_script true
    result = @executor.__mock_test_result
    expect(result[:pages]).to eql [{'gid' => '123', 'page' => 'Success!'}]
  end

  it "should execute find_output from script" do
    @executor.eval_parser_script true
    result = @executor.__mock_test_result
    expect(result[:find_output_args]).to eql ['collectionA', {'_id' => 'outputA'}]
  end

  it "should execute find_outputs from script" do
    @executor.eval_parser_script true
    result = @executor.__mock_test_result
    expect(result[:find_outputs_args]).to eql ['collectionB', {'_id' => 'outputB'}]
  end

  it "should eval without class context" do
    library_script = script = result = nil
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
      script = Tempfile.new(['parser_script', '.rb'], encoding: 'UTF-8')
      script.write "
        require '#{library_script.path.scan(/^(.+?)\.rb$/).first.first}'

        begin
          __mock_set_test_result Scraper.hello_world
        rescue Exception => e
          byebug
          __mock_set_test_result \"\#{e.message}\\n\#{e.backtrace}\"
        end
      "
      script.flush
      script.close

      # Create executor object and mock for test results
      executor = AnswersEngine::Scraper::RubyParserExecutor.new({
        filename: script.path,
        gid: '123',
        job_id: nil,
        page_vars: nil
      })
      class << executor
        define_method(:__mock_set_test_result){|result|@__mock_test_result = result}
        define_method(:__mock_test_result){@__mock_test_result}
        define_method(:exposed_methods){[:__mock_set_test_result].freeze}
        define_method(:init_page){{'gid' => '123'}}
      end

      # Test stuff
      executor.__mock_set_test_result 'FAIL'
      executor.eval_parser_script false
      result = executor.__mock_test_result
    ensure
      library_script.unlink unless library_script.nil?
      script.unlink unless script.nil?
    end
    expect(result).to eql "Hello world"
  end
end
