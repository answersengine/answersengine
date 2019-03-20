require 'test_helper'

describe 'executor' do
  before do
    @global_page = global_page = {
      'gid' => 'abc123',
      'url' => 'https://abc.com/123'
    }
    @job_page = job_page = @global_page.merge('job_id' => 111)
    @save_type = save_type = 'executor'
    @executor = AnswersEngine::Scraper::Executor.new
    class << @executor
      define_method(:save){true}
      define_method(:update_to_server) do |opts|
        @message_queue ||= []
        @message_queue << opts
        response = Object.new
        class << response
          define_method(:code){200}
          define_method(:body){''}
        end
        response
      end

      define_method(:mock_message_queue){@message_queue ||= []}
    end
    metaclass = class << @executor; self; end
    metaclass.define_method(:init_global_page){global_page}
    metaclass.define_method(:init_job_page){job_page}
    metaclass.define_method(:save_type){save_type}
    @executor.job_id = @job_page['job_id']
    @executor.gid = @job_page['gid']
  end

  describe 'unit test' do
    describe 'remove dups from list' do
      it 'should identify keys regardless symbol or string' do
        list = [
          {
            'aaa' => 'AAA',
            bbb: 'BBB',
            'ccc' => 'CCC',
            'eee' => 'EEE'
          }, {
            aaa: '111',
            'bbb' => '222',
            'ccc' => '333'
          }, {
            aaa: 'AAA',
            'bbb' => 'B2',
            'hhh' => 'H3',
            'mmm' => 'M9'
          }, {
            'aaa': 'AAA',
            'bbb' => 'B2',
            'ccc' => 'C3',
            'fff' => 'F7'
          }, {
            aaa: '111',
            'bbb' => '2B'
          },
          {
            'bbb' => 'bbb',
            'ggg' => '555',
            'yyy' => 'zzz'
          }
        ]
        key_defaults = {'aaa' => nil}
        dup_count = @executor.remove_old_dups! list, key_defaults
        expected = [
          {
            'aaa': 'AAA',
            'bbb' => 'B2',
            'ccc' => 'C3',
            'fff' => 'F7'
          }, {
            aaa: '111',
            'bbb' => '2B'
          },
          {
            'bbb' => 'bbb',
            'ggg' => '555',
            'yyy' => 'zzz'
          }
        ]
        assert_equal expected, list
      end

      it 'should count dups' do
        list = [
          {
            'aaa' => 'AAA',
            bbb: 'BBB',
            'ccc' => 'CCC',
            'eee' => 'EEE'
          }, {
            aaa: '111',
            'bbb' => '222',
            'ccc' => '333'
          }, {
            aaa: 'AAA',
            'bbb' => 'B2',
            'hhh' => 'H3',
            'mmm' => 'M9'
          }, {
            'aaa': 'AAA',
            'bbb' => 'B2',
            'ccc' => 'C3',
            'fff' => 'F7'
          }, {
            aaa: '111',
            'bbb' => '2B'
          },
          {
            'bbb' => 'bbb',
            'ggg' => '555',
            'yyy' => 'zzz'
          }
        ]
        key_defaults = {'aaa' => nil}
        dup_count = @executor.remove_old_dups! list, key_defaults
        expected = 3
        assert_equal expected, dup_count
      end

      it 'should add defaults' do
        list = [
          {
            'aaa' => 'AAA',
            bbb: 'BBB',
            'ccc' => 'CCC',
            'eee' => 'EEE'
          }, {
            aaa: '111',
            'bbb' => '222',
            'ccc' => '333'
          }, {
            aaa: 'AAA',
            'bbb' => 'B2',
            'hhh' => 'H3',
            'mmm' => 'M9'
          }, {
            'aaa': 'AAA',
            'bbb' => 'B2',
            'ccc' => 'C3',
            'fff' => 'F7'
          }, {
            aaa: '111',
            'bbb' => '2B'
          },
          {
            'bbb' => 'bbb',
            'ggg' => '555',
            'yyy' => 'zzz'
          }
        ]
        key_defaults = {'aaa' => 'AAA'}
        dup_count = @executor.remove_old_dups! list, key_defaults
        expected = [
          {
            aaa: '111',
            'bbb' => '2B'
          },
          {
            'bbb' => 'bbb',
            'ggg' => '555',
            'yyy' => 'zzz'
          }
        ]
        assert_equal expected, list
      end

      it 'should dedup outputs' do
        outputs = []
        outputs << {
          '_id' => 'aaa',
          '_collection' => 'my_collection',
          'name' => 'ABC'
        }
        outputs << {
          _id: 'aaa',
          _collection: 'my_collection',
          'name' => 'DEF'
        }
        outputs << {
          '_id' => 'aaa',
          '_collection' => 'my_collection_b',
          'name' => 'FFF'
        }
        outputs << {
          '_id' => 'bbb',
          '_collection' => 'my_collection',
          'name' => 'GGG'
        }
        dup_count = @executor.remove_old_output_dups! outputs
        expected = [
          {
            _id: 'aaa',
            _collection: 'my_collection',
            'name' => 'DEF'
          }, {
            '_id' => 'aaa',
            '_collection' => 'my_collection_b',
            'name' => 'FFF'
          }, {
            '_id' => 'bbb',
            '_collection' => 'my_collection',
            'name' => 'GGG'
          }
        ]
        assert_equal expected, outputs
      end

      # # TODO: Decomment this test once gid dedup is implemented.
      # it 'should dedup pages' do
      #   pages = []
      #   pages << {
      #     'gid' => 'aaa',
      #     'url' => 'https://example.com/aaa'
      #   }
      #   pages << {
      #     'gid' => 'aaa',
      #     'url' => 'https://example.com/bbb'
      #   }
      #   dup_count = @executor.remove_old_page_dups! pages
      #   expected = [
      #     {
      #       'gid' => 'aaa',
      #       'url' => 'https://example.com/bbb'
      #     }
      #   ]
      #   assert_equal expected, pages
      # end

      it 'should not dedup uniq pages' do
        pages = []
        pages << {
          'url' => 'https://example.com/aaa'
        }
        pages << {
          'url' => 'https://example.com/bbb'
        }
        dup_count = @executor.remove_old_page_dups! pages
        expected = [
          {
            'url' => 'https://example.com/aaa'
          }, {
            'url' => 'https://example.com/bbb'
          }
        ]
        assert_equal expected, pages
      end
    end
  end

  describe 'integration test' do


    describe 'save' do
      it 'should save pages' do
        pages = [
          {'url' => 'http://aaa.com'},
          {'url' => 'http://bbb.com'},
          {'url' => 'http://ccc.com'}
        ]
        @executor.save_pages pages
        expected = [
          {
            job_id: @job_page['job_id'],
            gid: @job_page['gid'],
            pages: [
              {'url' => 'http://aaa.com'},
              {'url' => 'http://bbb.com'},
              {'url' => 'http://ccc.com'}
            ],
            outputs: [],
            status: @save_type
          }
        ]
        assert_equal @executor.mock_message_queue.count, 1
        assert_equal expected, @executor.mock_message_queue
      end

      it 'should clear pages array on save' do
        pages = [
          {'url' => 'http://aaa.com'},
          {'url' => 'http://bbb.com'},
          {'url' => 'http://ccc.com'}
        ]
        @executor.save_pages pages
        expected = []
        assert_equal expected, pages
      end

      it 'should save outputs' do
        outputs = [
          {'_id' => '111', 'name' => 'aaa'},
          {'_id' => '111', _collection: 'my_collection', 'name' => 'bbb'},
          {'_id' => '111', _collection: 'default', 'name' => 'ccc'},
          {'_id' => '222', 'name' => 'ddd'},
          {'_id' => '111', '_collection' => 'default', 'name' => 'fff'},
        ]
        @executor.save_outputs outputs
        expected = [
          {
            job_id: @job_page['job_id'],
            gid: @job_page['gid'],
            pages: [],
            outputs: [
              {'_id' => '111', _collection: 'my_collection', 'name' => 'bbb'},
              {'_id' => '222', 'name' => 'ddd'},
              {'_id' => '111', '_collection' => 'default', 'name' => 'fff'},
            ],
            status: @save_type
          }
        ]
        assert_equal @executor.mock_message_queue.count, 1
        assert_equal expected, @executor.mock_message_queue
      end

      it 'should clear outputs array on save' do
        outputs = [
          {'_id' => '111', 'name' => 'aaa'},
          {'_id' => '111', _collection: 'my_collection', 'name' => 'bbb'},
          {'_id' => '111', _collection: 'default', 'name' => 'ccc'},
          {'_id' => '222', 'name' => 'ddd'},
          {'_id' => '111', '_collection' => 'default', 'name' => 'fff'},
        ]
        @executor.save_outputs outputs
        expected = []
        assert_equal expected, outputs
      end
    end
  end
end
