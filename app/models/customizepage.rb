

class Customizepage < ActiveRecord::Base
  attr_accessible :background_color, :coverimage, :favicon, :font_color, :greens, :link_color, :reds, :theme, :yellows, :customcss, :customheader, :customfooter, :logoname, :abouttext, :coverimageshow, :abouttexttitle, :systemcomponentstitle, :logo

  mount_uploader :favicon, FaviconUploader

  mount_uploader :coverimage, CoverimageUploader

  mount_uploader :logo, LogoUploader

  # :file_size => { 
  #     :maximum => 0.5.megabytes.to_i 
  #   }

  belongs_to :user
end