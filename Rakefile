require 'benchmark'
require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = ['lib', 'test']
  t.warning = false
  t.verbose = false
  t.test_files = FileList['./test/**/*_test.rb']
end

desc 'Benchmark another task execution | usage example: benchmark[my_task, param1, param2]'
task :benchmark, [:task] do |task, args|
  task_name = args[:task]
  if task_name.nil?
    puts "Should select a task."
    exit 1
  end
  puts Benchmark.measure{ Rake::Task[task_name].invoke *args.extras }
end

task default: :test
