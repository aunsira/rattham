class AddTaskModel < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :subject
      t.text :description
      t.string :status
    end
  end
end
