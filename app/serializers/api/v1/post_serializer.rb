class Api::V1::PostSerializer < ActiveModel::Serializer
  belongs_to :user

  has_many :comments do
    @object.comments.limit(5)
  end
  has_many :likes do
    @object.likes.limit(5)
  end

  attributes :id, :title, :description, :slug, :likes_count, :comments_count, :comments, :likes
end