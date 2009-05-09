class Category < ActiveRecord::Base
  has_many :units
  
  MONEY = "money"
  DISTANCE = "distance"
  WEIGHT = "weight"
  NUMBER = "number"
end