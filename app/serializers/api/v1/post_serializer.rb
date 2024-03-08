class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :slug, :likes_count, :comments_count, :user_id, :comments
end