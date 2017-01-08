class Article < ActiveRecord::Base

	has_attached_file	:image, 
						:path => ":attachment/:id/:style.:extension",
						styles: { medium: "680x300>", thumb: "170x75>" }
						#default_url: "/images/:style/missing.png" # peperclip

	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/ # paperclip
end
