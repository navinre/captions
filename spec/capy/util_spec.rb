require "spec_helper"

module Capy
  describe Util do
    include Util

    context "convert_to_msec" do

      it "converts time code in HH:MM:SS.SSS to milliseconds" do
        tc = "00:01:00.300"
        ms_per_frame = 40 # Assuming 25 pfs (1000 / 25)
        expect(convert_to_msec(tc, ms_per_frame)).to eq 60300
      end

      it "converts time code in HH:MM:SS:FF to milliseconds" do
        tc = "00:01:00:10"
        ms_per_frame = 40 # Assuming 25 pfs (1000 / 25)
        expect(convert_to_msec(tc, ms_per_frame)).to eq 60400
      end
    end

    context "convert_frame_rate" do
      it "converts milliseconds in one frame rate to another" do
        old_msec = 10400
        old_fps = 25
        new_fps = 29.97
        expect(convert_frame_rate(old_msec, old_fps, new_fps)).to eq 10334
      end
    end

    context "msec_to_timecode" do
      it "converts milliseconds to timecode format" do
        msec = 10000
        expect(msec_to_timecode(msec)).to eq "00:00:10.000"
      end
    end

    context "sanitize" do
      it "returns milliseconds when millisecond is passed" do
        expect(sanitize(1000)).to eq 1000
      end

      it "returns milliseconds when timecode is passed" do
        expect(sanitize("00:00:01.000")).to eq 1000
      end
    end

  end
end