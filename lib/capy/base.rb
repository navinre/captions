module Capy
  class Base

    def initialize(file)
      @cue_list = CueList.new
      @file = File.new(file, 'r:bom|utf-8')
    end

    def base_parser
      begin
        yield
      rescue => e
        puts e.message
      ensure
        @file.close
      end
    end

  end
end