module Captions

  # This module adds support for export of subtitles
  # from one format to another. Subclasses which
  # extends Captions::Base needs to `dump` method to
  # support export to that corresponding format
  module Export
    Captions.constants.each do |format|
      obj = Captions.const_get(format)
      next unless obj.is_a?(Class) and (obj.superclass == Captions::Base)
      method_name = "export_to_" + format.to_s.downcase
      define_method(method_name) do |file, cues=nil|
        sub_format = obj.new()
        sub_format.cues = cues || self.cues.dup
        sub_format.dump(file) if sub_format.respond_to?(:dump)
      end
    end
  end

  # Including this module after all the sub-classes of
  # Captions::Base has been defined.
  Captions::Base.send(:include, Export)

end

