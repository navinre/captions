module Capy

  # Used for all execptions thrown from Capy
  class CapyError < StandardError
  end

  # Subtitle has to be in correct format
  # when its being serialized
  class InvalidSubtitle < CapyError
  end

  # Subtitle has to be correct format
  # when its being parsed
  class MalformedString < CapyError
  end

  # File has to be specifed for parsing
  # subtitle
  class UnknownFile < CapyError
  end

  # Input has to be proper for filtering
  # subtitles
  class InvalidInput < CapyError
  end

end