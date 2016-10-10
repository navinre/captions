require "spec_helper"

module Capy
  describe Cue do

    it "creates new cue" do
      expect(Cue.new).not_to be nil
      expect(Cue.new.class).to eq Cue
    end

    context "serialize" do

      before :each do
        @cue = Cue.new
        t1 = "00:00:01.000"
        t2 = "00:00:02.000"
        dur = "00:00:01.000"
        @cue.set_time(t1, t2, dur)
        @fps = 25
        expect(@cue.start_time).not_to be nil
        expect(@cue.end_time).not_to be nil
        expect(@cue.duration).not_to be nil
      end

      it "converts start time, end time and duration" do
        @cue.serialize(@fps)
        expect(@cue.start_time).to eq 1000
        expect(@cue.end_time).to eq 2000
        expect(@cue.duration).to eq 1000
      end

      it "sets duration if not specified" do
        @cue.duration = nil
        @cue.serialize(@fps)
        expect(@cue.start_time).to eq 1000
        expect(@cue.end_time).to eq 2000
        expect(@cue.duration).to eq 1000
      end
    end

    context "change_frame_rate" do

      before :each do
        @cue = Cue.new
        @fps = 25
        @cue.set_time("00:00:10:10", "00:00:20:10")
        @cue.serialize(@fps)
        expect(@cue.start_time).to eq 10400
        expect(@cue.end_time).to eq 20400
      end

      # Assuming old frame rate is 25 fps
      it "changes time according to frame rate" do
        new_fps = 29.97
        @cue.change_frame_rate(@fps, new_fps)
        expect(@cue.start_time).to eq 10334
        expect(@cue.end_time).to eq 20334
      end

    end

    context "add_text" do
      before :each do
        @cue = Cue.new
        expect(@cue.text).to be nil
      end

      it "adds text" do
        @cue.add_text("hello")
        expect(@cue.text).to eq "hello"
      end

      it "appends new line if text was already present" do
        @cue.add_text("hello")
        @cue.add_text("world")
        expect(@cue.text.split("\n").count).to eq 2
      end
    end
  end
end