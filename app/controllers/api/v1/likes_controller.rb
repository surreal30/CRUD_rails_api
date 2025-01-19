class Api::V1::LikesController < ApplicationController
  before_action :set_like, only: %i[ show update destroy ]
  include Authentication

  # GET /likes
  def index
    likes = Like.find_by(post_id: params[:post_id])

    render json: likes
  end

  # GET /likes/1
  def show
    render json: @like
  end

  # POST /likes
  def create
    like = Post.find(params[:post_id]).likes.new(user: @user)

    if like.save
      render json: {post: post}, status: 201
    else
      render json: like.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /likes/1
  def update
    # Not a valid action
  end

  # DELETE /likes/1
  def destroy
    post = Post.find_by(id: @like.post_id)
    @like.destroy!
    render json: post, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end

    def method_missing(m, *args, &block)
      puts "this method is missing #{m}"
    end

    # Only allow a list of trusted parameters through.
    def like_params
      params.permit(:post_id)
    end
end
