class Task < ActiveRecord::Base
  validates :subject, presence: true, allow_blank: false
  validates :description, presence: true, allow_blank: false
  validates :status, presence: true, allow_blank: false
end