module Capy

  module Export
    Capy.constants.each do |format|
      obj = Capy.const_get(format)
      next unless obj.is_a?(Class) and (obj.superclass == Capy::Base)
      method_name = "export_to_" + format.to_s.downcase
      define_method(method_name) do |file|
        cl.dump(file) if cl.respond_to?(:dump)
      end
    end
  end

  Capy::Base.send(:include, Export)

end

