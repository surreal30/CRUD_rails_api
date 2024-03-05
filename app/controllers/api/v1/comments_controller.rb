class Api::V1::CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show update destroy ]
  include Authentication

  # GET /comments
  def index
    comments = Comment.where(post_id: params[:post_id])

    render json: comments
  end

  # GET /comments/1
  def show
    comment = Comment.where(post_id: params[:post_id], id: params[:id])

    render json: comment 
  end

  # POST /comments
  def create
    if authenticate
      post = Post.find(params[:post_id])
      user = User.find_by(username: request.headers[:username])
      comment = Comment.new(post: post, user: user, body: comment_params[:body])

      if comment.save 
        comments_count = post.comments_count + 1
        post.update(comments_count: comments_count)

        render json: {data: comment, count: post.comments_count}, status: 200
      else
        render status: :unprocessable_entity
      end
    else
      render status: 401
    end
  end

  # PATCH/PUT /comments/1
  def update
    if authenticate
      user = User.find_by(username: request.headers[:username])
      comment = Comment.where(post_id: params[:post_id], id: params[:id])
      comment = Post.find(params[:post_id]).comments.find(params[:id])
      render json: {comment: comment, id: comment.user_id}
      if comment.user_id == user.id
        if comment.update(comment_params)
          render json: comment
        else
          render json: comment.errors, status: :unprocessable_entity
        end
      else
        render status: 401
      end
    else
      render status: 401
    end
  end

  # DELETE /comments/1
  def destroy
    if authenticate
      user = User.find_by(username: request.headers[:username])
      comment = Post.find(params[:post_id]).comments.find(params[:id])
      if comment.user_id == user.id
        comment.destroy!
      else
        render status: 401
      end
    else
      render status: 401
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.permit(:body)
    end
end
