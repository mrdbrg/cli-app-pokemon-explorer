class Pokemon < ActiveRecord::Base
  belongs_to :location
  has_many :battles
end