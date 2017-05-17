require 'spec_helper'

module Captions
  describe SRT do

    before :all do
      @sample_file = "spec/sample/test.srt"
    end

    it "parses SRT file" do
      c = Captions::SRT.new(@sample_file)
      expect(c.parse).to be true
    end

    context "validate subtitle" do

      before :each do
        @subs = Captions::SRT.new(@sample_file)
        @subs.parse
      end

      it "has correct number of cues" do
        expect(@subs.cues.count).to eq 2
      end

      it "has correct start_time" do
        correct_values = [1600,2767]
        expect(@subs.cues.map{ |c| c.start_time}).to eq correct_values
      end

      it "has correct end_time" do
        correct_values = [2684,6021]
        expect(@subs.cues.map{ |c| c.end_time}).to eq correct_values
      end

      it "has correct duration" do
        correct_values = [1084, 3254]
        expect(@subs.cues.map{ |c| c.duration }).to eq correct_values
      end

      it "has correct text" do
        correct_values = [
          "Mr Developer, hi there.\n2004",
          "You are changing the sample subtitle\nused for captions test",
        ]
        expect(@subs.cues.map{ |c| c.text }).to eq correct_values
      end
    end
  end
end
