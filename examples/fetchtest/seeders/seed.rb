puts "hello from seeder"

pages << {
  url: "http://fetchtest.datahen.com/statuses/200?q=queuedFromParser",
  vars: {"abc":[1,2,3], "def": "defcontent"}
}
