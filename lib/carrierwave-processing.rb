require 'carrierwave-processing/version'

module CarrierWave
  module Processing
    autoload :RMagick, 'carrierwave-processing/rmagick'
    autoload :MiniMagick, 'carrierwave-processing/mini_magick'
  end
end
