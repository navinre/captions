module Captions

  # Used for all execptions thrown from captions
  class CaptionsError < StandardError
  end

  # Subtitle has to be in correct format
  # when its being serialized
  class InvalidSubtitle < CaptionsError
  end

  # Subtitle has to be correct format
  # when its being parsed
  class MalformedString < CaptionsError
  end

  # File has to be specifed for parsing
  # subtitle
  class UnknownFile < CaptionsError
  end

  # Input has to be proper for filtering
  # subtitles
  class InvalidInput < CaptionsError
  end

end