module Capy
  class CueList
    include Enumerable

    def initialize(frame_rate)
      @fps = frame_rate
      @list = []
    end

    def frame_rate=(rate)
      @list.each { |c| c.change_frame_rate(@fps, rate) }
      @fps = rate
    end

    def append(cue)
      @list << cue
    end

    def each
      @list.each { |c| yield(c) }
    end
  end
end