class TasksController < ApplicationController
    before_action :require_user_logged_in, only: [:index, :show,]
    before_action :correct_user, only: [:destroy, :show, :edit, :update]
    def index
        if logged_in?
            @task = current_user.tasks.build
            @tasks = current_user.tasks.order(id: :desc).page(params[:page])
        end
    end

  def show
     set_message
  end

  def new
      @task = Task.new
  end

  def create
     
      @task = current_user.tasks.build(task_params)
      if @task.save
          flash[:success] = "Taskが正常に投稿されました"
          redirect_to root_url
      else
          flash.now[:danger] = "Taskが投稿されませんでした"
          render :new
      end
  end

  def edit
      set_message
  end

  def update
      set_message
      if @task.update(task_params)
          flash[:success] = "Taskは正常に更新されました"
          redirect_to root_path
      else
          flash.now[:danger] = "Taskは更新されませんでした"
          render :edit
      end
  end

  def destroy
    set_message
    @task.destroy
    flash[:success] = 'Task は正常に削除されました'
    redirect_to root_url
  end
  
  private 
  
  def set_message
      @task = Task.find(params[:id])
  end
  
  def task_params
      params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
        redirect_to root_url
    end
  end
end
