require "spec_helper"

module Captions
  describe Base do

    before :each do
      @sample_file = 'spec/sample/test.srt'
      @fps = 25
      @block = lambda { |c| }
      @base = Captions::Base.new(@sample_file, @fps)
      @sample_dump = "spec/sample/sample_dump"
    end

    it "has export module" do
      modules = Captions::Base.ancestors.select { |c| c.class == Module }
      expect(modules.include?(Export)).to be true
    end

    context "creates new object" do
      it "when file specified" do
        expect(@base.class).to eq Base
        expect(@base.instance_variable_get("@file")).not_to be nil
        expect(@base.instance_variable_get("@cue_list")).not_to be nil
      end

      it "when file not specified" do
        c = Captions::Base.new()
        expect(c.class).to eq Base
        expect(c.instance_variable_get("@file")).to be nil
        expect(c.instance_variable_get("@cue_list")).not_to be nil
      end
    end

    context "base_parse" do

      before :each do
        @block = lambda {  }
      end

      it "expects a block" do
        expect { @base.send(:base_parser) }.to raise_error
      end

      it "parses file if specified and closes it"  do
        expect { @base.send(:base_parser, &@block) }.not_to raise_error
        file = @base.instance_variable_get("@file")
        expect(file.closed?).to be true
      end

      it "thows error if file not specified" do
        base = Captions::Base.new()
        expect { base.send(:base_parser, &@block) }.to raise_error
      end

      it "parses file in frame rate specified" do
        cue_list = @base.instance_variable_get('@cue_list')
        expect(cue_list.instance_variable_get('@fps')).to eq @fps
      end
    end

    context "base_dump" do

      before :all do
        @sample_dump = "spec/sample/sample_dump"
      end

      it "requires block" do
        expect { @base.send(:base_dump, @sample_dump) }.to raise_error(LocalJumpError)
      end

      it "dumps subtitles to a file" do
        expect { @base.send(:base_dump, @sample_dump, &@block) }.not_to raise_error
      end
    end

    context "cues" do
      it "returns cue list" do
        expect(@base.cues).not_to be nil
        expect(@base.cues.class).to be CueList
      end

      it "accepts block and returns new cue list" do
        old_cues = @base.cues.hash
        expect { @base.cues { } }.not_to raise_error
        new_cues = @base.cues { }
        expect(new_cues.hash).not_to eq old_cues
      end
    end

    context "fetch_result" do
      before :each do
        cue = Cue.new()
        cue.set_time("00:00:01:00", "00:00:02:00")
        @base.cues.append(cue)
      end

      it "returns result if a block is passed" do
        expect { @base.send(:fetch_result, &@block) }.not_to raise_error
        block = lambda { |cue| cue.start_time > 3000 }
        result = @base.send(:fetch_result, &@block).count
        expect(result).to eq 0
      end

      it "returns whole list if block is not passed" do
        expect(@base.send(:fetch_result).count).to eq 1
      end
    end

    context "frame_rate" do
      it "changes frame rate in cue list" do
        new_fps = 29.97
        @base.set_frame_rate(new_fps)
        cue_list = @base.cues
        expect(cue_list.instance_variable_get('@fps')).to eq new_fps
      end
    end

    context "move_by" do

      before :each do
        cue = Cue.new()
        cue.set_time("00:00:01:00", "00:00:02:00")
        @base.cues.append(cue)
      end

      it "moves subtitles by n milliseconds" do
        @base.move_by(1000)
        expect(@base.cues.first.start_time).to eq 2000
        expect(@base.cues.first.end_time).to eq 3000
      end

      it "accepts input as milliseconds" do
        expect { @base.move_by(1000) }.not_to raise_error
      end

      it "accepts input as Timecode" do
        expect { @base.move_by("00:00:01:00") }.not_to raise_error
        expect(@base.cues.first.start_time).to eq 2000
        expect(@base.cues.first.end_time).to eq 3000
      end

      it "thows error on wrong input" do
        expect { @base.move_by("00:00:00:0000") }.to raise_error(CaptionsError)
      end
    end

    context "increase_duration_by" do

      before :each do
        cue = Cue.new()
        cue.set_time("00:00:01:00", "00:00:02:00")
        @base.cues.append(cue)
      end

      it "increses duration of subtitles by n milliseconds" do
        @base.increase_duration_by(1000)
        expect(@base.cues.first.duration).to eq 2000
      end

      it "accepts input as milliseconds" do
        expect { @base.increase_duration_by(1000) }.not_to raise_error
      end

      it "accepts input as Timecode" do
        expect { @base.increase_duration_by("00:00:01:00") }.not_to raise_error
        expect(@base.cues.first.duration).to eq 2000
      end

      it "thows error on wrong input" do
        expect { @base.increase_duration_by("00:00:00:0000") }.to raise_error(CaptionsError)
      end
    end

    context "filter and export" do
      before :each do
        3.times do |i|
          cue = Cue.new()
          cue.set_time("00:00:0#{i+1}:00", "00:00:02:00")
          @base.cues.append(cue)
        end
      end

      it "filters part of subtitles" do
        cues = @base.cues { |c| c.start_time < 2000 }
        expect(cues.to_a.length).to eq 1
      end

      it "filters and exports to subtitles" do
        cues = @base.cues { |c| c.start_time < 2000 }
        expect(cues.to_a.length).to eq 1
        expect(@base.export_to_vtt(@sample_dump, cues)).to be true
      end
    end

  end
end
