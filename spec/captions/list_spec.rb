require "spec_helper"

module Captions
  describe CueList do
    it "creates cue list" do
      fps = 25
      list = CueList.new(25)
      expect(list.class).to be CueList
      expect(list.instance_variable_get('@fps')).to eq fps
    end

    context "append" do

      before :each do
        @fps = 25
        @cue_list = CueList.new(@fps)
        expect(@cue_list.instance_variable_get('@list').count).to eq 0
      end

      it "inserts cue into the list" do
        cue = Cue.new
        cue.set_time("00:00:01:00", "00:00:02:00")
        @cue_list.append(cue)
        expect(@cue_list.instance_variable_get('@list').count).to eq 1
      end

      it "will not insert if start time / end time is not set" do
        cue = Cue.new
        expect { @cue_list.append(cue) }.to raise_error(CaptionsError)
      end
    end


    context "frame_rate assignment" do

      before :each do
        @fps = 25
        @cue_list = CueList.new(@fps)
        expect(@cue_list.instance_variable_get('@fps')).to eq @fps
      end

      it "changes frame rate" do
        new_fps = 29.97
        @cue_list.frame_rate = new_fps
        expect(@cue_list.instance_variable_get('@fps')).to eq new_fps
      end
    end

    context "can respond to" do
      before :each do
        @fps = 25
        @cue_list = CueList.new(@fps)
        @cue = Cue.new
        @cue.set_time("00:00:01:00", "00:00:02:00")
        @cue_list.append(@cue)
        expect(@cue_list.instance_variable_get('@list').count).to eq 1
      end

      it "each" do
        expect(@cue_list.each.class).to eq Enumerator
      end

      it "array accessor" do
        expect(@cue_list[0]).to eq @cue
        expect(@cue_list[-1]).to eq @cue
      end

      it "sort" do
        expect { @cue_list.sort }.not_to raise_error
      end
    end
  end
end
