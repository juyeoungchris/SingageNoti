class Noti < ApplicationRecord
	belongs_to :user 
	# belongs_to :wysiwyg
	has_attached_file :image,:default_url => "missing.png", styles: { medium:"200x200>" , small: "100x100>"} 
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
