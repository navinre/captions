module Captions
  class Cue
    include Util

    # Text Properties supported
    ALIGNMENT    = "alignment"
    COLOR        = "color"
    POSITION     = "position"

    # List of Text Properties
    TEXT_PROPERTIES = [ALIGNMENT, COLOR, POSITION]

    attr_accessor :number, :start_time, :end_time, :duration, :text, :properties

    # Creates a new Cue class
    # Each cue denotes a subtitle.
    def initialize(cue_number = nil)
      self.text = nil
      self.start_time = nil
      self.end_time = nil
      self.duration = nil
      self.number = cue_number
      self.properties = {}
    end

    # Sets the time for the cue. Both start-time and
    # end-time can be passed together. This just assigns
    # the value passed.
    def set_time(start_time, end_time, duration = nil)
      self.start_time = start_time
      self.end_time = end_time
      self.duration = duration
    end

    # Getter and Setter methods for Text Properties
    # These are pre-defined properties. This is just to assign
    # or access the properties of that text.
    TEXT_PROPERTIES.each do |setting|
      define_method :"#{setting}" do
        if self.properties[setting].present?
          return self.properties[setting]
        end
        return nil
      end

      define_method :"#{setting}=" do |value|
        self.properties[setting] = value
      end
    end

    # Serializes the values set for the cue.
    # Converts start-time, end-time and duration to milliseconds
    # If duration is not found, it will be calculated based on
    # start-time and end-time.
    def serialize(fps)
      raise InvalidSubtitle, "Subtitle should have start time" if self.start_time.nil?
      raise InvalidSubtitle, "Subtitle shold have end time" if self.end_time.nil?

      begin
        ms_per_frame = (1000.0 / fps)
        self.start_time = convert_to_msec(self.start_time, ms_per_frame)
        self.end_time = convert_to_msec(self.end_time, ms_per_frame)
        if duration.nil?
          self.duration = self.end_time - self.start_time
        else
          self.duration = convert_to_msec(self.duration, ms_per_frame)
        end
      rescue
        raise InvalidSubtitle, "Cannot calculate start-time or end-time"
      end
    end

    # Changes start-time, end-time and duration based on new frame-rate
    def change_frame_rate(old_rate, new_rate)
      self.start_time = convert_frame_rate(self.start_time, old_rate, new_rate)
      self.end_time = convert_frame_rate(self.end_time, old_rate, new_rate)
      self.duration = convert_frame_rate(self.duration, old_rate, new_rate)
    end

    # Adds text. If text is already found, new-line is appended.
    def add_text(text)
      if self.text.nil?
        self.text = text
      else
        self.text += "\n" + text
      end
    end

    def <=>(other_cue)
      self.start_time <=> other_cue.start_time
    end
  end
end
