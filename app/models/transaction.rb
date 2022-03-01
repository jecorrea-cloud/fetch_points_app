class Transaction < ApplicationRecord
    
     #Validations before entering the database
     validates :payer, :points, :timestamp, presence: true

     #Helper class methods for the spend method in the controller

end
