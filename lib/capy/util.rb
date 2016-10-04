module Capy
  module Util

    def convert_to_msec(text)
      msec = 0
      tc_split = text.split('.')
      time_split = tc_split[0].split(':')
      if tc_split[1]  # msec component exists
        msec = tc_split[1].ljust(3, '0').to_i  # pad with trailing 0s to make it 3 digit
      end
      min = 60
      hour = min * 60
      # Get HH:MM:SS in seconds
      sec = time_split[-1].to_i
      sec += time_split[-2].to_i * min
      sec += time_split[-3].to_i * hour

      msec += sec * 1000
      return msec
    end

  end
end