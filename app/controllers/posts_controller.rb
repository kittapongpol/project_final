class PostsController < ApplicationController
    before_action :authorize_request, only: [:create, :update, :destroy]
  
    def index
      posts = Post.all
      render json: posts
    end
  
    def create
      post = @current_user.posts.create(post_params)
      render json: post, status: :created
    end
  
    def update
      post = @current_user.posts.find(params[:id])
      post.update(post_params)
      render json: post
    end
  
    def destroy
      post = @current_user.posts.find(params[:id])
      post.destroy
      render json: { message: 'Post deleted' }
    end
  
    private
  
    def post_params
      params.require(:post).permit(:title, :content)
    end
  
    def authorize_request
      header = request.headers['Authorization']
      token = header.split(' ').last if header
      decoded = JWT.decode(token, 'secret')[0]
      @current_user = User.find(decoded['user_id'])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  