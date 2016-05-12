module Api
  module V1
    class TasksController < ApplicationController

      def_param_group :task do
        param :subject, String, "Subject"
        param :description, String
        param :status, String
      end

      api :GET, '/v1/tasks', 'View all items in the list'
      def index
        render json: {task: Task.all}
      end

      api :GET, '/v1/tasks/:id', 'View a single task in the list'
      param :id, String, :desc => "Task Id", :required => true
      def show
        @task = Task.find(params[:id])
        render json: {task: @task}
      end

      api :POST, '/v1/tasks/:id', 'Edit existing task'
      param :id, String, :desc => "Task Id", :required => true
      param_group :task
      def update
        @task = Task.find(params[:id])
        if @task.update(task_params)
          render json: {task: @task}
        else
          render json: {message: @task.errors.full_messages}
        end
      end

      def new
        @task = Task.new
      end

      api :POST, '/v1/tasks/', 'Add new task to the list'
      param_group :task
      def create
        @task = Task.new(task_params)
        if @task.save
          render json: {task: @task}
        else
          render json: {message: @task.errors.full_messages}
        end
      end

      api :PATCH, '/v1/tasks/:id/update_status/', 'Set task status'
      param :id, String, :desc => "Task Id", :required => true
      param :status, String, :desc => "Task's status", :required => true
      def set_status
        @task = Task.find(params[:id])
        if @task
          @task.status = params[:status]
          @task.save
          render json: {task: @task}
        else
          render json: {message: "cant find task for id: #{params[:id]}"}
        end
      end

      api :DELETE, '/v1/tasks/:id', 'Delete a specific task'
      param :id, String, :desc => "Task Id", :required => true
      def destroy
        @task = Task.find(params[:id])
        @task.destroy
        render json: {message: "Task id: #{params[:id]} was deleted successfully"}
      end

      private
      def task_params
        params.require(:task).permit(:subject, :description, :status)
      end
    end
  end
end
