module Captions
  module Util

    # TC should be HH:MM:SS:FF (frames) or HH:MM:SS.MSC (milliseconds).
    # FF(2 digits) and MSC(3 digits) are optional.
    TIMECODE_REGEX = /^-?([01]\d|2[0-3]):[0-5]\d:[0-5]\d(:\d{2}|\.\d{3})?$/

    # Currently considering frame rate as 25
    # Converts time-code in HH:MM:SS.MSEC (or) HH:MM:SS:FF (or) MM:SS.MSEC
    # to milliseconds.
    def convert_to_msec(tc, ms_per_frame=40)
      msec = 0
      negative_multiplier = 1
      if tc[0] == '-'
        tc = tc[1..-1]  # remove -ve sign
        negative_multiplier = -1
      end
      tc_split = tc.split('.')
      time_split = tc_split[0].split(':')

      # To handle MM:SS.MSEC format
      if time_split.length == 2
        time_split.unshift('00')
      end

      if tc_split[1]  # msec component exists
        msec = tc_split[1].ljust(3, '0').to_i  # pad with trailing 0s to make it 3 digit
      elsif time_split.length == 4  # FF (frame) component exists
        msec = time_split[-1].to_i * ms_per_frame.to_f
        time_split.pop  # so that below code can work from last index
      end

      min = 60
      hour = min * 60
      # Get HH:MM:SS in seconds
      sec = time_split[-1].to_i
      sec += time_split[-2].to_i * min
      sec += time_split[-3].to_i * hour

      msec += sec * 1000

      return (negative_multiplier * msec.round) # to be consistent with tc_to_frames which also rounds
    end

    # Converts milliseconds calculated in one frame-rate to another frame-rate
    def convert_frame_rate(msec, old_fps, new_fps)
      old_ms_per_frame = (1000.0 / old_fps)
      new_ms_per_frame = (1000.0 / new_fps)
      frames = (msec / old_ms_per_frame).round  # Number of frames in old fps
      sec = frames / old_fps
      frames = frames % old_fps
      new_frames = sec * new_fps
      new_frames += frames # Number of frames in new fps
      return (new_frames * new_ms_per_frame).round  # MSEC in new fps
    end

    # Converts milliseconds to timecode format
    # Currently returns HH:MM:SS.MSEC
    # Supports upto 60 hours
    def msec_to_timecode(milliseconds)
      seconds = milliseconds / 1000
      msec = milliseconds % 1000
      secs = seconds % 60

      seconds = seconds / 60
      mins = seconds % 60

      seconds = seconds / 60
      hours = seconds % 60

      format("%02d:%02d:%02d.%03d",hours, mins, secs ,msec)
    end

    # Parses time-code and converts it to milliseconds.
    # If time cannot be converted to milliseconds,
    # it throws InvalidInput Error
    def sanitize(time, frame_rate)
      if time.is_a?(String)
        if TIMECODE_REGEX.match(time)
          time = convert_to_msec(time, frame_rate)
        end
      end
      raise InvalidInput, 'Input should be in Milliseconds or Timecode' unless time.is_a? (Fixnum)
      return time
    end
  end
end