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
      self.start_time = start_time
      self.end_time = end_time
      self.duration = duration
    end

    def serialize(fps)
      raise InvalidSubtitle, "Subtitle should have start time" if self.start_time.empty?
      raise InvalidSubtitle, "Subtitle shold have end time" if self.end_time.empty?

      ms_per_frame = (1000.0 / fps)
      self.start_time = convert_to_msec(self.start_time, ms_per_frame)
      self.end_time = convert_to_msec(self.end_time, ms_per_frame)
      if duration.nil?
        self.duration = self.end_time - self.start_time
      else
        self.duration = convert_to_msec(self.duration, ms_per_frame)
      end
    end

    def change_frame_rate(old_rate, new_rate)
      self.start_time = convert_frame_rate(self.start_time, old_rate, new_rate)
      self.end_time = convert_frame_rate(self.end_time, old_rate, new_rate)
      self.duration = convert_frame_rate(self.duration, old_rate, new_rate)
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
