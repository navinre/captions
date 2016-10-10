module Capy
  class CueList

    # Creates a new CueList
    def initialize(frame_rate)
      @fps = frame_rate
      @list = []
    end

    # Returns frame-rate of the list
    def fps
      @fps
    end

    # Hide all cues when inspecting CueList
    # Show only necessary info rather than printing everything
    def inspect
      "#<Capy::CueList:#{object_id} @fps=#{fps} @cues=#{@list.count}>"
    end

    # Changes the frame rate of CueList
    # This also changes frame rate in already parsed
    # subtitles
    def frame_rate=(rate)
      @list.each { |c| c.change_frame_rate(@fps, rate) }
      @fps = rate
    end

    # Inserts the subtitle into the CueList
    # Subtitle is serialized before its inserted
    def append(cue)
      cue.serialize(@fps)
      @list << cue
    end

    # Iterate through CueList
    def each
      @list.each { |c| yield(c) }
    end
  end
end