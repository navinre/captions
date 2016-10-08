module Capy
  class Cue
    include Util

    attr_accessor :number, :start_time, :end_time, :duration, :text, :property

    def initialize
      self.text = nil
      self.start_time = nil
      self.end_time = nil
      self.duration = nil
      self.number = nil
      self.property = {}
    end

    def set_time(start_time, end_time, duration = nil)
      self.start_time = convert_to_msec(start_time)
      self.end_time = convert_to_msec(end_time)
      if duration.nil?
        self.duration = self.end_time - self.start_time
      else
        self.duration = convert_to_msec(duration)
      end
    end

    def change_frame_rate(old_rate, new_rate)
      old_ms_per_frame = (1000 / old_rate.to_f)
      new_ms_per_frame = (1000 / new_rate.to_f)
      self.start_time = (self.start_time / old_ms_per_frame) * new_ms_per_frame
      self.end_time = (self.end_time / old_ms_per_frame) * new_ms_per_frame
      self.duration = (self.duration / old_ms_per_frame) * new_ms_per_frame
    end

    def add_text(text)
      if self.text.nil?
        self.text = text
      else
        self.text += "\n" + text
      end
    end

  end
end
