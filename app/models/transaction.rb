class Transaction < ApplicationRecord

     #Validations before entering the database
     validates :payer, :points, :timestamp, presence: true

     #Helper class methods for the spend method in the controller

     
     def total
        total_points = 0
        current_points = []
        self.all.map do |t|
            current_points << t.points
        end
        total_points = current_points.sum
     end


end
