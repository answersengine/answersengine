require 'tempfile'

RSpec.describe AnswersEngine::Scraper::RubySeederExecutor do
  before(:all) do
    @seeder_script = Tempfile.new(['seeder_script', '.rb'], encoding: 'UTF-8')
    @seeder_script.write "
      pages << {'gid' => '123', 'page' => 'Success!'}
      save_pages [{'page' => 'pageA'}, {'page' => 'pageB'}]
    "
    @seeder_script.flush
    @seeder_script.close
  end

  after(:all) do
    @seeder_script.unlink
  end

  before(:each) do
    @executor = AnswersEngine::Scraper::RubySeederExecutor.new({
      filename: @seeder_script.path,
      job_id: nil
    })
    # Mock executor for test results
    class << @executor
      define_method(:__mock_set_test_result){|result|@__mock_test_result = result}
      define_method(:__mock_test_result){@__mock_test_result}
      define_method(:save_pages) do |*args|
        @__mock_test_result = [] if @__mock_test_result.nil?
        @__mock_test_result << args
      end
    end
  end

  it "should save pages from script" do
    @executor.eval_seeder_script true
    result = @executor.__mock_test_result
    expect(result[1]).to eql [[{'gid' => '123', 'page' => 'Success!'}], true]
  end

  it "should execute save_pages from script" do
    @executor.eval_seeder_script true
    result = @executor.__mock_test_result
    expect(result[0]).to eql [[{'page' => 'pageA'}, {'page' => 'pageB'}]]
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
      script = Tempfile.new(['seeder_script', '.rb'], encoding: 'UTF-8')
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
      executor = AnswersEngine::Scraper::RubySeederExecutor.new({
        filename: script.path,
        job_id: nil
      })
      class << executor
        define_method(:__mock_set_test_result){|result|@__mock_test_result = result}
        define_method(:__mock_test_result){@__mock_test_result}
        define_method(:exposed_methods){[:__mock_set_test_result].freeze}
      end

      # Test stuff
      executor.__mock_set_test_result 'FAIL'
      executor.eval_seeder_script false
      result = executor.__mock_test_result
    ensure
      library_script.unlink unless library_script.nil?
      script.unlink unless script.nil?
    end
    expect(result).to eql "Hello world"
  end
end
