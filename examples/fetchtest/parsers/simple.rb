nokogiri = Nokogiri.HTML(content)

outputs << {
    _collection: "home",
    _id: "1234",
    text: nokogiri.text,
    heading: nokogiri.at('h1').text,
    response_headers: page['response_headers'],
}

pages << {
  url: "http://fetchtest.datahen.com/statuses/200?q=queuedFromParser",
  vars: {"abc":[1,2,3], "def": "defcontent"}
}
