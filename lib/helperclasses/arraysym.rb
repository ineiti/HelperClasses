
module HelperClasses
  module ArraySym
    refine Array do
      # Comptaibility for Ruby < 1.9
      if ! Array.respond_to? :to_h
        def to_h
          Hash[ *self ]
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