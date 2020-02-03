module Captions
  class SRT < Base

    def parse
      base_parser do
        count = 0
        state = :new_cue
        cue = nil
        loop do
          count += 1
          line = @file.gets
          break if line.nil? ## End of file
          line.strip!
          case state
          when :new_cue
            next if line.empty?  ## just another blank line, remain in new_cue state
            begin
              cue = Cue.new(Integer(line))
            rescue ArgumentError
              raise InvalidSubtitle, "Invalid Cue Number at line #{count}"
            end
            state = :time
          when :time
            raise InvalidSubtitle, "Invalid Time Format at line #{count}" unless is_time?(line)
            start_time, end_time = get_time(line)
            cue.set_time(start_time, end_time)
            state = :text
          when :text
            if line.empty?
              ## end of previous cue
              @cue_list.append(cue) if cue && cue.start_time
              cue = nil
              state = :new_cue
            else
              cue.add_text(line)
            end
          end
        end
        @cue_list.append(cue) if cue && cue.start_time
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
