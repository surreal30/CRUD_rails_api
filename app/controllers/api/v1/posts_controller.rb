class Api::V1::PostsController < ApplicationController
  include Authentication

  def index
    posts = Post.all

    if posts
      render json: {data: posts}, status: :ok
    else
      render json: posts.errors, status: :bad_request
    end
  end

  def create
    if authenticate
      post = Post.new(post_params)

      # render json: {params: post_params, post: post}
      if post.save
        post.update(slug: "api/v1/posts/#{post.id}")
        render json: {data: post}, status: 201
      else
        render json: post.errors, status: :unprocessale_entity
      end
    else
      render status: 401
    end
  end

  def show
    begin
    post = Post.find(params[:id])
      render json: { data: post }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end
  end

  def destroy
    if authenticate
      post = Post.find(params[:id])

      user = User.find_by(username: request.headers[:username])
      if post.user_id == user.id
        if post.destroy!
          render json: {message: "Post deleted successfully"}, status: 204
        else
          render json: {message: "Post does not exist"}, status: :bad_request
        end
      else
        render status: 401
      end
    else
      render status: 401
    end
  end

  def update
    if authenticate
      post = Post.find(params[:id])
      user = User.find_by(username: request.headers[:username])
      if post.user_id == user.id
        if post.update!(post_params)
          render json: {data: post}, status: 200
        else
          render status: :unprocessale_entity
        end
      else
        render status: 401
      end
    else
      render status: 401
    end
  end

  def like
    if authenticate
      begin
        post = Post.find(params[:post_id])
        post.increment(:likes_count)
        render json: {data: post, code: "works"}, status: 200

      rescue
        render status: 404
      end
    else
      render status: 401
    end
  end

  private
  def post_params
    user = User.find_by(username: request.headers[:username])
    params.permit(:title, :description).with_defaults(slug: "", likes_count: 0, comments_count: 0, user: user)
  end
end