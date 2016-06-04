require 'spec_helper'
require 'rails_helper'

describe 'Tasks API' do
  describe "GET /tasks", type: :request do
    it "returns all the tasks" do
      FactoryGirl.create :task, subject: "foo", description: "description", status: "pending"
      FactoryGirl.create :task, subject: "bar", description: "test description", status: "done"

      get "/api/v1/tasks", {}, { "Accept" => "application/json" }

      expect(response.status).to eq 200
      body = JSON.parse(response.body)

      task_subject_foo = body.map { |m| m[1][0]['subject'] }
      task_subject_bar = body.map { |m| m[1][1]['subject']}

      expect(task_subject_foo).to match_array(["foo"])
      expect(task_subject_bar).to match_array(["bar"])
    end
  end

  describe "GET /tasks/:id", type: :request do
    it "returns single task" do
      t = FactoryGirl.create :task, subject: "foo", description: "description", status: "pending"

      get "/api/v1/tasks/#{t.id}", {}, { "Accept" => "application/json" }

      expect(response.status).to eq 200
      body = JSON.parse(response.body)
      task_subject = body.map { |m| m[1]['subject'] }

      expect(task_subject).to match_array(["foo"])
    end
  end

  describe "PUT /tasks/:id", type: :request do
    it "updates existing task" do
      t = FactoryGirl.create :task, subject: "foo", description: "description", status: "done"
      expect(Task.first.subject).to eq "foo"

      task_params = {
        "task" => {
          "subject" => "bar"
        }
      }.to_json

      request_header = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      put "/api/v1/tasks/#{t.id}", task_params, request_header

      expect(response.status).to eq 200
      expect(Task.first.subject).to eq "bar"
    end
  end

  describe "POST /tasks", type: :request do
    it "creates new tasks to the list" do
      task_params = {
        "task" => {
          "subject" => "foo",
          "description" => "description",
          "status" => "done"
        }
      }.to_json

      request_header = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      post "/api/v1/tasks", task_params, request_header

      expect(response.status).to eq 200
      expect(Task.first.subject).to eq "foo"
    end
  end

  describe "PATCH /tasks/:id/update_status", type: :request do
    it "updates task's status" do
      t = FactoryGirl.create :task, subject: "foo", description: "description", status: "In progress"
      expect(Task.first.subject).to eq "foo"
      expect(Task.first.status).to eq "In progress"

      request_header = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      patch "/api/v1/tasks/#{t.id}/update_status?status=done", {}, request_header

      expect(response.status).to eq 200
      expect(Task.first.status).to eq "done"
    end
  end

  describe "DELETE /tasks/:id", type: :request do
    it "deletes task" do
      t = FactoryGirl.create :task, subject: "foo", description: "description", status: "done"
      expect(Task.first.subject).to eq "foo"

      request_header = {
        "Accept" => "application/json",
        "Content-Type" => 'application/json'
      }

      delete "/api/v1/tasks/#{t.id}", {}, request_header

      expect(response.status).to eq 200
      expect(Task.count).to eq 0
    end
  end
end
