# frozen_string_literal: true

class PostsController < ApplicationController
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
          render turbo_stream: turbo_stream.replace(dom_id(Post.new), partial: 'posts/form', locals: { post: @post })
        end
      end
    end
  end

  def edit; end

  def update; end

  private

  def post_params
    params.require(:post).permit(:city, :notice)
  end
end
