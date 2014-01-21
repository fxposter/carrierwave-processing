module CarrierWave
  module Processing
    module MiniMagick
      # Strips out all embedded information from the image
      #
      #   process :strip
      #
      def strip
        manipulate! do |img|
          img.strip
          img = yield(img) if block_given?
          img
        end
      end

      # Reduces the quality of the image to the percentage given
      #
      #   process :quality => 90
      #
      def quality(percentage)
        manipulate! do |img|
          img.quality(percentage.to_s)
          img = yield(img) if block_given?
          img
        end
      end

      # Sets the colorspace of the image to the specified value.
      #
      #   process :colorspace => :rgb # force rgb
      #   process :colorspace => :cmyk # force cmyk
      #
      def colorspace(cs)
        manipulate! do |img|
          img.combine_options do |c|
            case cs.to_sym
            when :rgb
              c.colorspace "sRGB"
            when :cmyk
              c.colorspace "CMYK"
            end
          end
          img = yield(img) if block_given?
          img
        end
      end

      # reduce image noise and reduce detail levels
      #
      #   process :blur => [0, 8]
      #
      def blur(radius, sigma)
        manipulate! do |img|
          img.blur "#{radius}x#{sigma}"
          img = yield(img) if block_given?
          img
        end
      end

    end
  end
end
