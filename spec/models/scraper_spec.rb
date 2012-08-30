require "spec_helper"

describe Scraper do
  subject { Scraper }

  context "constants" do
    it "has a list of blacklisted image names" do
      subject::BLACKLIST.should == ["sprite", "icon", "transparent"]
    end
  end
  context "initializing a new scraper" do

    it "sets the status to fail" do
      scraper = subject.new("foo")
      scraper.instance_eval { @response }.should == { "status" => "fail" }
      scraper.instance_eval { @page }.should be_nil
    end

    it "parses a valid url with nokogiri" do
      scraper = subject.new("#{Rails.root}/spec/factories/valid.html")
      scraper.instance_eval { @response }.should == { "status" => "ok" }
      scraper.instance_eval { @page.class }.should == Nokogiri::HTML::Document
    end
  end
end

describe Scraper, "#scrape" do
  context "when the status is fail" do
    it "it does not return title, description and images in the response" do
      scraper = Scraper.new("foo")
      scraper.scrape.should == { "status" => "fail" }
    end
  end

  context "when status is ok" do
    it "response contains title, description and images" do
      scraper = Scraper.new("#{Rails.root}/spec/factories/valid.html")
      scraper.scrape.should == {
                                  "status"      => "ok",
                                  "title"       => "Valid Title",
                                  "description" => "valid description",
                                  "images"      => ["/s3.amazonaws.com/images/valid.png"]
                               }
    end

    it "response contains empty title, description and images if not found on page" do
      scraper = Scraper.new("#{Rails.root}/spec/factories/no_data.html")
      scraper.scrape.should == {
                                  "status"      => "ok",
                                  "title"       => "",
                                  "description" => "",
                                  "images"      => []
                               }
    end

    it "blacklisted images are removed from the response" do
      scraper = Scraper.new("#{Rails.root}/spec/factories/blacklist.html")
      scraper.scrape.should == {
                                  "status"      => "ok",
                                  "title"       => "Valid Title",
                                  "description" => "valid description",
                                  "images"      => ["/s3.amazonaws.com/images/valid.png"]
                               }
    end
  end

  context "with a limit parameter" do
    it "returned images are <= limit" do
      scraper = Scraper.new("#{Rails.root}/spec/factories/multiple_images.html")
      scraper.scrape(2).should == {
                                  "status"      => "ok",
                                  "title"       => "Valid Title",
                                  "description" => "valid description",
                                  "images"      => ["/s3.amazonaws.com/images/valid.png", "/s3.amazonaws.com/images/valid_01.png"]
                               }
    end
  end
end
