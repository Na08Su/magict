ActiveAdmin.register Project do
permit_params :name, :content, :price, :image

  show do |t|
    attributes_table do
      row :name
      row :content
      row :price
      row :image do
        project.image? ? image_tag(project.image.url, height: '100') : content_tag(:span, "No photo yet!")
      end
    end
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :name
      f.input :content
      f.input :price
      f.input :image, hint: f.project.image? ? image_tag(project.image.url, height: '100') : content_tag(:span, "upload JPG/PNG/GIF image")
    end
    f.actions
  end
end



# imageカラムに対してPAPERCLIPを使う