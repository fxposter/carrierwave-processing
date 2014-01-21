module CarrierWave
  module Processing
    module RMagick
      # Strips out all embedded information from the image
      def strip
        manipulate! do |img|
          img.strip!
          img = yield(img) if block_given?
          img
        end
      end

      # Reduces the quality of the image to the percentage given
      def quality(percentage)
        manipulate! do |img|
          img.write(current_path){ self.quality = percentage }
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
            img.colorspace = Magick::RGBColorspace
          when :cmyk
            img.colorspace = Magick::CMYKColorspace
          end
          img = yield(img) if block_given?
          img
        end
      end


      # reduce image noise and reduce detail levels
      # 
      #   process :blur => [0,8]
      #
      def blur(radius,sigma)
        manipulate! do |img|
          img.blur(radius,sigma)
          img = yield(img) if block_given?
          img
        end
      end

    end
  end
end
