class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
  belongs_to :user

  validates :body, length: {minimum: 4}, format: {with: /\A[a-zA-Z 0-9!@#$^&*()_-]*\z/, message: 'must be alphanumeric and !@#$^&*()_- only'} 
end
