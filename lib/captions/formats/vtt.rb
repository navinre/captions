module Captions
  class VTT < Base

    # Header used for all VTT files
    VTT_HEADER = "WEBVTT"

    # VTT file comments/style section
    VTT_METADATA = /^NOTE|^STYLE/

    # Parse VTT file and update CueList
    def parse
      base_parser do
        count = 1
        cue_count = 0
        meta_data_section = false
        cue = nil
        raise InvalidSubtitle, "Invalid VTT Signature" unless validate_header(@file.gets)
        while(line = @file.gets) do
          line = line.strip
          if line.empty?
            meta_data_section = false
          elsif is_meta_data?(line)
            meta_data_section = true
          elsif is_time?(line)
            @cue_list.append(cue) if cue
            cue_count += 1
            cue = Cue.new
            cue.number = cue_count
            line = line.split
            cue.set_time(line[0], line[2])
          elsif !meta_data_section and is_text?(line)
            cue.add_text(line)
          end
        end
        @cue_list.append(cue) if cue
      end
    end

    # Export CueList to VTT file
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

    # Check whether its a VTT_HEADER or not
    def validate_header(line)
      !!line.strip.match(/^#{VTT_HEADER}/)
    end

    # Check whether its a meta-data or not
    def is_meta_data?(text)
      !!text.match(VTT_METADATA)
    end

    # Timecode format used in VTT file
    def is_time?(text)
      !!text.match(/^(\d{2}:)?\d{2}:\d{2}.\d{3}.*(\d{2}:)?\d{2}:\d{2}.\d{3}/)
    end

    # Check whether if its subtilte text or not
    def is_text?(text)
      !text.empty? and text.is_a?(String) and text != VTT_HEADER
    end

  end
end