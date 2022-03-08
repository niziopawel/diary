# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[edit update destroy]
  include ActionView::RecordIdentifier

  def index
    @post = Post.new
    @posts = current_user.posts.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.temperature = 25

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(dom_id(Post.new),
                                                    partial: 'posts/form',
                                                    locals: { post: @post, title: 'Create post' })
        end
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to posts_path, notice: 'Post was successfully updated.' }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(dom_id(@post),
                                                    partial: 'posts/form',
                                                    locals: { post: @post, title: 'Create post' })
        end
      end
    end
  end

  def destroy
    @post.destroy

    redirect_to posts_path, notice: 'Post was successfully destroyed.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:city, :notice)
  end
end
