class Contact < ActiveRecord::Base
  attr_accessible :lastname, :name, :phone
  belongs_to :user
end
