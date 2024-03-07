class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :user_id, uniqueness: {scope: :post_id, message: "post already liked by the user"}
end
