module Capy

  module Export
    Capy.constants.each do |format|
      obj = Capy.const_get(format)
      next unless obj.is_a?(Class) and (obj.superclass == Capy::Base)
      method_name = "export_to_" + format.to_s.downcase
      define_method(method_name) do |file|
        sub_format = obj.new()
        sub_format.cues = self.cues.dup
        sub_format.dump(file) if sub_format.respond_to?(:dump)
      end
    end
  end

  Capy::Base.send(:include, Export)

end

