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

  end
end
