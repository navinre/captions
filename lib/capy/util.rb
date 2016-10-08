module Capy
  module Util

    # TC should be HH:MM:SS:FF (frames) or HH:MM:SS.MSC (milliseconds). FF(2 digits) and MSC(3 digits) are optional.
    # FF is 2 digit only, so limited to 99 fps which should be safe for now.
    TIMECODE_REGEX = /^-?([01]\d|2[0-3]):[0-5]\d:[0-5]\d(:\d{2}|\.\d{3})?$/

    # Currently considering frame rate as 25
    def convert_to_msec(tc, ms_per_frame=40)
      msec = 0
      negative_multiplier = 1
      if tc[0] == '-'
        tc = tc[1..-1]  # remove -ve sign
        negative_multiplier = -1
      end
      tc_split = tc.split('.')
      time_split = tc_split[0].split(':')

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

    def sanitize(time)
      if time.is_a?(String)
        if TIMECODE_REGEX.match(time)
          time = convert_to_msec(time)
        end
      end
      return time
    end
  end
end