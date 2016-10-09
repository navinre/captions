module Capy

	class CapyError < StandardError
	end

	class InvalidSubtitle < CapyError
	end

	class MalformedString < CapyError
	end

	class UnknownFile < CapyError
	end

end