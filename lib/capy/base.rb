module Capy
  class Base

    # Adding Util methods so that it can be used by
    # any subtitle parser
    include Util

    # Creates new instance of parser
    # Usage:
    #     p = Capy::Base.new(nil, 25)
    #
    # This creates new cue-list with no file object
    # associated with it. `parse` method cannot be
    # called if no file path is specified.
    #
    #    p = Capy::Base.new('file_path', 25)
    #
    # This parses the file specified in the file path
    # `parse` method will be defined in any one of the
    # classes which extends this base class. This parses
    # the file in the fps specified. If a subtitle file
    # has to be parsed in different fps, it can be passed
    # as a parameter. FPS parameter plays an important
    # role if the start-time or end-time of a subtitle is
    # mentioned in frames (i.e) HH:MM:SS:FF (frames)
    def initialize(file=nil, fps=25)
      @cue_list = CueList.new(fps)
      @file = File.new(file, 'r:bom|utf-8') if file
    end

    # This overrides the existing cuelist which has been
    # populated with a new cuelist. This is mainly used in
    # export of one format to another.
    def cues=(cue_list)
      @cue_list = cue_list
    end

    ############## BEGINNING OF OPERATIONS #################
    ## Following Operations can performed on subtitles

    # A subtitle is parsed with 25 fps by default. This default
    # value can be changed when creating a new parser class.
    # When the subtitle is being parsed, it takes the value
    # mentioned when the class is created. Even after the
    # subtitle is parsed, frame rate (fps) can be changed using
    # this method.
    # Usage:
    #     p = Capy::Base.new('file_path', 25)
    #     p.parse
    #     p.set_frame_rate(29.97)
    #
    # This method changes all the subtitle which are parsed to
    # the new frame rate.
    def set_frame_rate(rate)
      @cue_list.frame_rate = rate
    end

    # This returns the subtitle which are parsed. A block
    # can also be passed to filter the cues based on following
    # parameters.
    # Usage:
    #     p.cues
    #     p.cues { |c| c.start_time > 1000 }
    #     p.cues { |c| c.end_time > 1000 }
    #     p.cues { |c| c.duration > 1000 }
    #
    # Filters based on the condition and returns new set of cues
    def cues(&block)
      if block_given?
        base = self.class.new()
        base.cues = fetch_result(&block)
        return base.cues
      else
        @cue_list
      end
    end

    # Moves subtitles by `n` milliseconds
    # Usage:
    #     p.move_by(1000)
    #     p.move_by("00:00:02.000")
    #     p.move_by(1000) { |c| c.start_time > 2000 }
    #
    # This changes start-time and end-time of subtiltes by
    # the time passed.
    def move_by(diff, &block)
      msec = sanitize(diff, frame_rate)
      fetch_result(&block).each do |cue|
        cue.start_time += msec
        cue.end_time += msec
      end
    end

    # Increases duration of subtitles by `n` milliseconds
    # Usage:
    #     p.increase_duration_by(1000)
    #     p.increase_duration_by("00:00:02.000")
    #     p.increase_duration_by(1000) { |c| c.start_time > 2000 }
    #
    # This increases duration of subtiltes by the time passed.
    def increase_duration_by(diff, &block)
      msec = sanitize(diff, frame_rate)
      fetch_result(&block).each do |cue|
        cue.duration += msec
      end
    end

    ################ END OF OPERATIONS ###################

    private

    # This is the base method through which all subtitle
    # file parsing should be done. This throws error if
    # no `@file` is found. This also closes the file once
    # the file has be parsed. All other logic like when the
    # subtitle has to be inserted into the list, when to set
    # the start and end time will be defined inside `parse`
    # method.
    def base_parser
      raise UnknownFile, "No subtitle file specified" if @file.nil?
      begin
        yield
      ensure
        @file.close
      end
    end

    # This is the base method through which all subtitle
    # exports has to be done. When a `file_path` is passed
    # to this base method, it opens the file. Other logic
    # about how the file should be written is defined inside
    # `dump` method in one of the subclass.
    def base_dump(file)
      begin
        File.open(file, 'w') do |file|
          yield(file)
        end
      end
    end

    # This returns the frame-rate which was used for parsing
    # the subtitles
    def frame_rate
      @cue_list.fps
    end

    # This accepts a block and returns the result based
    # on the condition passed. This acts on the cuelist
    # whenever a block is passed it does select with the
    # condition passed and returns the result. When no
    # block is passed, it returns the entire cuelist.
    def fetch_result(&block)
      if block_given?
        @cue_list.select(&block)
      else
        @cue_list
      end
    end
  end
end
