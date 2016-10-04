module Capy
  class SRT < Base

    def parse
      base_parser do
        count = 1
        cue = nil
        while(line = @file.gets) do
          line = line.strip
          if is_number?(line)
            @cue_list.append(cue) if cue
            cue = Cue.new
            cue.number = line.to_i
          elsif is_time?(line)
            s , e = get_time(line)
            cue.set_time(s, e)
          elsif is_text?(line)
            cue.add_text(line)
          elsif !line.empty?
            puts "Malformed SRT at line #{count}"
            break
          end
          count += 1
        end
        @cue_list.append(cue)
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