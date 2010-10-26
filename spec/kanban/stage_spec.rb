require 'spec_helper'

describe Stage do

  it "should add cards to stages" do
    stage(['A', 'B'], limit=2).cards.size.should eql(2)
  end

  it "should batch add cards to stages" do
    stage = Stage.new('test')
    stage.add_cards('A, B, C');
    stage.cards[0].should eql('A')
    stage.cards[2].should eql('C')
  end

  it "should warn wip limit violations" do
    stage(['A', 'B']).wip_limit_violated?.should be_false
    stage(['A', 'B'], limit=2).wip_limit_violated?.should be_false
    stage(['A', 'B', 'C'], limit=2).wip_limit_violated?.should be_true
  end

  it "should add substages by name and limit" do
    stage = Stage.new('development', limit=2)
    stage.add_substage('to do')
    stage.add_substage('done')
    stage.substages.size.should eql(2)
  end

  it "should add substages by name, limit and cards" do
    stage = Stage.new('development', limit=5)
    stage.add_substage('to do', limit=3, cards='A,B,Cc')
    stage.substages[0].limit.should eql(3)
    stage.substages[0].cards[2].should eql('Cc')
  end

  it "should list all substages cards" do
    stage_with_substages.substages_cards.should eql(['A', 'B', 'C'])
  end
  
  it "should warn wip limit violations from substages" do
    stage = stage_with_substages
    stage.wip_limit_violated?.should be_false

    stage.substages[1].add_card('C')
    stage.wip_limit_violated?.should be_true
  end

  it "should not accept cards if it has stages"
  it "should not accept stages if it has cards"

  protected

  def stage(cards, limit=0)
    stage =  Stage.new('development', limit)
    cards.each {|card| stage.add_card card}
    stage
  end

  def stage_with_substages
    stage = Stage.new('development', limit=3)
    stage.add_substage('to do', limit=nil, cards='A,B')
    stage.add_substage('done', limit=nil, cards='C')
    stage
  end

end
