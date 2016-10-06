module Capy
  class Base

    def initialize(file, fps=25)
      @cue_list = CueList.new(fps)
      @file = File.new(file, 'r:bom|utf-8')
    end

    def base_parser
      begin
        yield
      rescue => e
        puts e.message
      ensure
        @file.close
      end
    end

    def base_dump(file)
      begin
        yield
      rescue => e
        puts e.message
      ensure
        file.close
      end
    end

    def set_frame_rate=(rate)
      @cue_list.frame_rate = rate
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
