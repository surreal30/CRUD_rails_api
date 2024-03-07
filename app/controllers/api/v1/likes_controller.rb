class Api::V1::LikesController < ApplicationController
  before_action :set_like, only: %i[ show update destroy ]
  include Authentication

  # GET /likes
  def index
    likes = Like.all

    render json: likes
  end

  # GET /likes/1
  def show
    render json: like
  end

  # POST /likes
  def create
    if authenticate
      post = Post.find(params[:post_id])
      like = Like.new(post: post, user: @user)

      unless Like.where(post_id: post.id, user_id: @user.id).present?
        if like.save
          likes_count = post.likes_count + 1
          post.update(likes_count: likes_count)

          render json: {post: post}
        else
          render json: like.errors, status: :unprocessable_entity
        end
      else
        render status: 400
      end
    else
      render status: 401
    end
  end

  # PATCH/PUT /likes/1
  def update
    if like.update(like_params)
      render json: like
    else
      render json: like.errors, status: :unprocessable_entity
    end
  end

  # DELETE /likes/1
  def destroy
    like.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      like = Like.find(params[:id])
    end

    def method_missing(m, *args, &block)
      puts "this method is missing #{m}"
    end

    # Only allow a list of trusted parameters through.
    def like_params
      params.permit(:post_id)
    end
end
