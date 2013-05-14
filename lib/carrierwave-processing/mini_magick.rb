module CarrierWave
  module Processing
    module MiniMagick
      # Strips out all embedded information from the image
      def strip
        manipulate! do |img|
          img.strip
          img = yield(img) if block_given?
          img
        end
      end

      # Reduces the quality of the image to the percentage given
      def quality(percentage)
        manipulate! do |img|
          img.quality(percentage.to_s)
          img = yield(img) if block_given?
          img
        end
      end

      # Sets the colorspace of the image to the specified value.
      # 
      #   process :rgb # force rgb
      #   process :cmyk # force cmyk
      # 
      def colorspace(cs)
        manipulate! do |img|
          case cs.to_sym
          when :rgb
            img.colorspace = "RGBColorspace"
          when :cmyk
            img.colorspace = "CMYKColorspace"
          end
          img = yield(img) if block_given?
          img
        end
      end

    end
  end
end
