class Request < ActiveRecord::Base
	belongs_to :user
	has_many :likes, dependent: :destroy # requestが消されたら一緒にlikeも削除
end
