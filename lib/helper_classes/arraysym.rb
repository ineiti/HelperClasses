
module HelperClasses
  module ArraySym
    class Array
      # Comptaibility for Ruby <= 2.0
      if ![].respond_to? :to_h
        def to_h
          Hash[*self.flatten]
        end
      end

      def to_sym
        collect{|v| v.to_sym }
      end

      def to_sym!
        self.replace( to_sym() )
      end
    
      def to_s
        "[#{join(",")}]"
      end
    end
  end
end