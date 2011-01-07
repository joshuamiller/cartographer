require "spec_helper"
describe Cartographer::ClusterIcon do

  before do

  end

  after do

  end

  it "should accept valid Style configuration for producing style object" do
    icon = Cartographer::ClusterIcon.new({:marker_type => "icon_name"})
    #push first variant
    icon << {
            :url => '/image_smallest.gif',
            :height => 18,
            :width => 10,
            :opt_anchor => [10, 0],
            :opt_textColor => 'black'
          }
   #push second variant
   icon << {
            :url => '/image_normal.gif',
            :height => 21,
            :width => 15,
            :opt_anchor => [20, 0],
            :opt_textColor => 'black'
          }

  #push third variant
   icon << {
            :url => '/image_biggest.gif',
            :height => 27,
            :width => 19,
            :opt_anchor => [26, 0],
            :opt_textColor => 'black'
          }

    icon.to_js.should include("/image_biggest.gif"); #there should be better way to test it | TODO
  end



end