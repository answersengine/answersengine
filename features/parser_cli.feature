Feature: AnswersEngine
  In order to develop scraper for AnswersEngine
  As a CLI
  I want to write and test parsers locally


  Scenario: scraper parse
    When I run `answersengine scraper parse ruby index.rb www.ebay.com-b3cc6226318ba6ba8e4a268341490fb35df24f141d95d9ebfccf8ffdd86ab364`
    Then the output should contain "Parsing parser_type:ruby parser_file:index.rb gid:www.ebay.com-b3cc6226318ba6ba8e4a268341490fb35df24f141d95d9ebfccf8ffdd86ab364"
