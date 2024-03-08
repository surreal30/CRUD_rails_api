class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, length: {minimum: 5, maximum: 256}, format: {with: /\A[a-zA-Z 0-9!@#$^&*()_-]*\z/, message: 'must be alphanumeric and !@#$^&*()_- only'}
  validates :description, length: {minimum: 10}, format: {with: /\A[a-zA-Z 0-9!@#$^&*()_-]*\z/, message: 'must be alphanumeric and !@#$^&*()_- only'} 
end
