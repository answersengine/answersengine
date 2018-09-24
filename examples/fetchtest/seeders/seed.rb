puts "hello from seeder"

pages << {
  url: "http://fetchtest.datahen.com/statuses/200?q=queuedFromParser",
  vars: {"abc":[1], "def": "defcontent"}
}

pages << {
  url: "http://fetchtest.datahen.com/statuses/200?q=queuedFromParser2",
  vars: {"abc":[2], "def": "defcontent"}
}

save_pages(pages)

pages << {
  url: "http://fetchtest.datahen.com/statuses/200?q=queuedFromParser3",
  vars: {"abc":[3], "def": "defcontent"}
}

pages << {
  url: "http://fetchtest.datahen.com/statuses/200?q=queuedFromParser4",
  vars: {"abc":[3], "def": "defcontent"}
}

pages << {
  url: "http://fetchtest.datahen.com/statuses/200?q=queuedFromParser5",
  vars: {"abc":[3], "def": "defcontent"}
}
