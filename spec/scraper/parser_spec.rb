RSpec.describe AnswersEngine::Scraper::Parser do
  it "returns hello world" do
    expect(AnswersEngine::Scraper::Parser.hello("world")).to eql "Hello world"
  end
end
