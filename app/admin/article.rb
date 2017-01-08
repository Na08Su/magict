ActiveAdmin.register Article do
	permit_params :title, :content, :image

	show do |t|
		attributes_table do
			row :title
			row :content
			row :image do
				content_tag(:span, :image)#article.image? ? image_tag(article.image_url, height: '100') : content_tag(:span, "まだ写真がありません!")
			end
		end
	end

	form :html => { :enctype => "multipart/form-data" } do |f|
		f.inputs do
			f.input :title
			f.input :content
			f.input :image#, hint: f.article.image? ? image_tag(article.image.url, height: '100') : content_tag(:span, "upload JPG/PNG/GIF image")
		end
		f.actions
	end
end

	# モデル名articleを使っていることがエラーの原因 htmlでarticleを変換する際にクラッシュしている模様 (http://www.rubydoc.info/github/gregbell/arbre/Arbre/HTML)