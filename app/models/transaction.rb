class Transaction < ApplicationRecord
     #Validations before entering the database
     validates :payer, :points, :timestamp, presence: true
end
