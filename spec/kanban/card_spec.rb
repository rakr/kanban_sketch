require 'spec_helper'

describe Card do
  subject{Card.new(" name")}

  it "should have name" do
    subject.name.should_not be_nil
  end
  it "should strip name" do
    subject.name.should == "name"
  end
end