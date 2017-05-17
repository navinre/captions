module Captions
  class SRT < Base

    def parse
      base_parser do
        count = 1
        cue = Cue.new
        number = nil
        lines = []
        while(line = @file.gets) do
          line = line.strip
          if line.empty?
            @cue_list.append(cue) if cue and cue.start_time
            cue = Cue.new
            # This is done to handle white spaces at the beginning
            # and end of the file
            if(number = @file.gets)
              # Reads the number immediately followed by white-space
              cue.number = number.to_i
            else
              cue = nil
            end
          elsif is_time?(line)
            s , e = get_time(line)
            cue.set_time(s, e)
          elsif is_text?(line)
            cue.add_text(line)
          elsif !line.empty?
            raise MalformedString, "Invalid format at line #{count}"
          end
          count += 1
        end
        @cue_list.append(cue) if cue
      end
    end

    def dump(file)
      base_dump(file) do |file|
        @cue_list.each do |cue|
          file.write(cue.number)
          file.write("\n")
          file.write(msec_to_timecode(cue.start_time).gsub!('.' , ','))
          file.write(" --> ")
          file.write(msec_to_timecode(cue.end_time).gsub!('.' , ','))
          file.write("\n")
          file.write(cue.text)
          file.write("\n\n")
        end
      end
    end

    def get_time(line)
      data = line.split('-->')
      return format_time(data[0]), format_time(data[1])
    end

    def format_time(text)
      text.strip.gsub(/,/,".")
    end

    def is_number?(text)
      !!text.match(/^\d+$/)
    end

    def is_time?(text)
      !!text.match(/^\d{2}:\d{2}:\d{2},\d{3}.*\d{2}:\d{2}:\d{2},\d{3}$/)
    end

    def is_text?(text)
      !text.empty? and text.is_a?(String)
    end

  end
end
