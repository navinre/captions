module Capy
	class VTT < Base

		VTT_HEADER = "WEBVTT"

		def parse
			base_parser do
				count = 1
				cue_count = 0
				cue = nil
				while(line = @file.gets) do
					line = line.strip
					if line.empty?
						@cue_list.append(cue) if cue
						cue_count += 1
						cue = Cue.new
						cue.number = cue_count
					elsif is_time?(line)
						s, e = get_time(line)
						cue.set_time(s, e)
					elsif is_text?(line)
						cue.add_text(line)
					end
				end
				@cue_list.append(cue)
			end
		end

		def dump(file)
			base_dump(file) do |file|
				file.write(VTT_HEADER)
				@cue_list.each do |cue|
					file.write("\n\n")
					file.write(msec_to_timecode(cue.start_time))
					file.write(" --> ")
					file.write(msec_to_timecode(cue.end_time))
					file.write("\n")
					file.write(cue.text)
				end
			end
		end

    def is_time?(text)
      !!text.match(/^\d{2}:\d{2}:\d{2}.\d{3}.*\d{2}:\d{2}:\d{2}.\d{3}/)
    end

    def get_time(line)
      data = line.split('-->')
      return data[0], data[1]
    end

    def is_text?(text)
      !text.empty? and text.is_a?(String) and text != VTT_HEADER
    end

	end
end