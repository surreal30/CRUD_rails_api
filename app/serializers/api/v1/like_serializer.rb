class Api::V1::LikeSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :post_id
end
