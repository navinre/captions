require 'spec_helper'

module Captions
  describe VTT do

    before :all do
      @sample_file = "spec/sample/test.vtt"
    end

    it "parses VTT file" do
      c = Captions::VTT.new(@sample_file)
      expect(c.parse).to be true
    end

    context "validate subtitle" do

      before :each do
        @subs = Captions::VTT.new(@sample_file)
        @subs.parse
      end

      it "has correct number of cues" do
        expect(@subs.cues.count).to eq 3
      end

      it "has correct start_time" do
        correct_values = [4080,6400,8300]
        expect(@subs.cues.map{ |c| c.start_time}).to eq correct_values
      end

      it "has correct end_time" do
        correct_values = [6320,7880,9400]
        expect(@subs.cues.map{ |c| c.end_time}).to eq correct_values
      end

      it "has correct duration" do
        correct_values = [2240,1480,1100]
        expect(@subs.cues.map{ |c| c.duration }).to eq correct_values
      end

      it "has correct text" do
        correct_values = [
          "I'm going to flip through this deck.",
          "And I want you to see one card.",
          "Not this one. That's too obvious."
        ]
        expect(@subs.cues.map{ |c| c.text }).to eq correct_values
      end

      it "parses properties" do
        correct_values = [
          {"alignment"=>"start", "position"=>90},
          {"alignment"=>"middle", "position"=>-1},
          {"alignment"=>"middle", "position"=>90}
        ]
        expect(@subs.cues.map{ |c| c.properties }).to eq correct_values
      end
    end
  end
end
