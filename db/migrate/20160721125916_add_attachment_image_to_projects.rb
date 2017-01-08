class AddAttachmentImageToProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :projects, :image
  end
end

# paperclip
#attachmentは、Paperclipが定義しているファイルで、ファイル情報を保持するための複数のカラムを追加します。
