puts `pwd`

require './libraries/hello'

hello = Hello.new
puts "hello say #{hello.say}"
puts "page gid:#{page['gid']}"
puts "page #{page}"

puts "content #{content}"

nokogiri = Nokogiri.HTML(content)

h1 = nokogiri.at('h1')
heading = h1.nil? ? '' : h1.text 
text = nokogiri.text

doc1 = {
    _collection: "home",
    # _id: "1234",
    text: text,
    heading: heading,
    response_headers: page['response_headers'],
    some_vars: page['vars']
    # url: page.url
}
doc2 = {
    _collection: "home",
    # _id: "12345",
    text: text,
    heading: heading,
    response_headers: page['response_headers'],
    some_vars: page['vars']
    # url: page.url
}


outputs << doc1
outputs << {}
outputs << doc2


pages << {
  url: "http://fetchtest.datahen.com/statuses/200?q=queuedFromParserWithVars",
  vars: {"abc":[1,2,3], "def": "defcontent"}
}

puts "inspect page: #{page}"

puts "inspect vars: #{page['vars']}"
