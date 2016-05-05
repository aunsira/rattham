module Api
  module V1
    class TasksController < ApplicationController
      def index
        render json: {task: Task.all}
      end

      def show
        @task = Task.find(params[:id])
        render json: {task: @task}
      end

      def update
        @task = Task.find(params[:id])
        if @task.update(task_params)
          render json: {task: @task}
        else
          render json: {message: 'something wrong'}
        end
      end

      def new
        @task = Task.new
      end

      def create
        @task = Task.new(task_params)
        if @task.save
          render json: {task: @task}
        else
          render json: {message: 'something wrong'}
        end
      end

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
