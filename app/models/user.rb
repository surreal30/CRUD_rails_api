class User < ApplicationRecord
  validates :username, presence: true, length: {minimum: 4}, uniqueness: true, format: {with: /\A[a-zA-Z][a-zA-Z0-9_-]*\z/, message: 'must contain only alphanumeric and _-'}
  validates :password, presence: true, length: {minimum: 8}
end