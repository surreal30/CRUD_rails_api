class Api::V1::CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show update destroy ]
  include Authentication
  include Authorization
  before_action :authenticate

  # GET /comments
  def index
    comments = Comment.where(post_id: params[:post_id])

    render json: comments, status: 200
  end

  # GET /comments/1
  def show
    render json: @comment, status: 200
  end

  # POST /comments
  def create
    comment = Post.find(params[:post_id]).comments.new(user: @user, body: comment_params[:body])

    if comment.save 
      render json: {data: comment}, status: 200
    else
      render json: {error_message: comment.errors, error_code: 422}, status: 422
    end
  end

  # PATCH/PUT /comments/1
  def update
    if authorized?(@comment)
      if @comment.update(comment_params)
        render json: @comment
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    else
      render json: {error_message: "Unauthorized user", error_code: 401}, status: 401
    end
  end

  # DELETE /comments/1
  def destroy
    if authorized?(@comment)
      @comment.destroy!
    else
      render json: {error_message: "Unauthorized user", error_code: 401}, status: 401
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find_by(post_id: params[:post_id], id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.permit(:body)
  end
end
