class Api::V1::PostsController < ApplicationController
  include Authentication
  before_action :authenticate

  def index
    posts = Post.all

    if posts
      render json: posts, status: :ok
    else
      render json: {error: "Post not found", error_code: 404}, status: 404
    end
  end

  def create
    post = Post.new(post_params)

    if post.save
      post.update(slug: "api/v1/posts/#{post.id}")
      render json: post, status: 201
    else
      render json: post.errors, status: 422
    end
  end

  def show
    post = Post.find_by(id: params[:id])
    if post
      render json: post, status: :ok
    else
      render json: {error: "Post not found", error_code: 404}, status: 404
    end
  end

  def destroy
    post = Post.find_by(id: params[:id])
    if post
      if post.user_id == @user.id
        if post.destroy!
          render json: {message: "Post deleted successfully"}, status: 204
        else
          render json: {message: "Post does not exist"}, status: :bad_request
        end
      else
        render status: 401
      end
    else
      render json: {error: "Post not found", error_code: 404}, status: 404
    end

  end

  def update
    post = Post.find_by(id: params[:id])
    if post
      if post.user_id == @user.id
        if post.update!(post_params)
          render json: post, status: 200
        else
          render status: 422
        end
      else
        render status: 401
      end
    else
      render json: {error: "Post not found", error_code: 404}, status: 404
    end
  end

  private
  def post_params
    params.permit(:title, :description).with_defaults(slug: "", likes_count: 0, comments_count: 0, user: @user)
  end
end