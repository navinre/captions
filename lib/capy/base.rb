module Capy
  class Base

    include Util

    def initialize(file=nil, fps=25)
      @cue_list = CueList.new(fps)
      @file = File.new(file, 'r:bom|utf-8') if file
    end

    def base_parser
      begin
        yield
      ensure
        @file.close
      end
    end

    def base_dump(file)
      begin
        File.open(file, 'w') do |file|
          yield(file)
        end
      end
    end

    def set_frame_rate=(rate)
      @cue_list.frame_rate = rate
    end

    def cues(&block)
      if block_given?
        base = self.class.new()
        base.cues = fetch_result(&block)
        return base
      else
        @cue_list
      end
    end

    def cues=(cue_list)
      @cue_list = cue_list
    end

    ## Operations performed on subtitles
    def move_by(diff, &block)
      msec = sanitize(diff)
      fetch_result(&block).each do |cue|
        cue.start_time += msec
        cue.end_time += msec
      end
    end

    def increase_duration_by(diff, &block)
      msec = sanitize(diff)
      fetch_result(&block).each do |cue|
        cue.duration += msec
      end
    end


    def fetch_result(&block)
      if block_given?
        @cue_list.select(&block)
      else
        @cue_list
      end
    end

  end
end
