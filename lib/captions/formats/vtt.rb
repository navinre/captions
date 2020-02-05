module Captions
  class VTT < Base

    # Header used for all VTT files
    VTT_HEADER = "WEBVTT"

    # VTT file comments/style section
    VTT_METADATA = /^NOTE|^STYLE/

    # Auto Keyword used in Alignment
    AUTO_KEYWORD = "auto"

    # Alignment Data
    ALIGNMENT_VALUES = {
      "middle" => "middle",
      "center" => "middle",
      "left"   => "left",
      "right"  => "right",
      "start"  => "start",
      "end"    => "end",
    }

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
            set_properties(cue, line[3..-1])
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

    def set_properties(cue, properties)
      properties.each do |prop|
        prop, value = prop.split(":")
        value.gsub!("%","")
        case prop
        when "align"
          cue.alignment = get_alignment(value)
        when "line"
          value = value.split(",")[0]
          cue.position = get_line(value)
        end
      end
    end

    def get_alignment(value)
      raise InvalidSubtitle, "Invalid VTT Alignment Property" unless ALIGNMENT_VALUES[value]
      return ALIGNMENT_VALUES[value]
    end

    def get_line(value)
      raise InvalidSubtitle, "VTT Line property should be a valid number" if !is_integer?(value) and value != AUTO_KEYWORD
      return value.to_i
    end

    def get_position(value)
      raise InvalidSubtitle, "VTT Position should be a valid number" if !is_integer?(value)
      raise InvalidSubtitle, "VTT Position should be a number between 0 to 100" if (value.to_i < 0) or (value.to_i > 100)
      return value.to_i
    end

    def is_integer?(val)
      val.to_i.to_s == val
    end
  end
end
