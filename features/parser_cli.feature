Feature: AnswersEngine
  In order to develop scraper for AnswersEngine
  As a CLI
  I want to write and test parsers locally

  Scenario: Hello world
    When I run `answersengine hello John`
    Then the output should contain "Hello John"
