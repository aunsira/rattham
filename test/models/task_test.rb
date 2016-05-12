require 'test_helper'

class TaskTest < ActiveSupport::TestCase

  def setup
    @task = Task.new(subject: 'test', description: 'description', status: 'status')
  end

  test "that task should be valid" do
    assert @task.valid?
  end

  test "that subject should be present" do
    @task.subject = ' '
    assert_not @task.valid?
  end

  test "that description should be present" do
    @task.subject = ''
    assert_not @task.valid?
  end

  test "that status should be present" do
    @task.status = ' '
    assert_not @task.valid?
  end

end