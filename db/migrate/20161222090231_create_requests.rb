class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
    	t.string :title
    	t.string :description
    	t.references :user, index: true, foreign_key: true
    	t.timestamps null: false
    end
  end
end
