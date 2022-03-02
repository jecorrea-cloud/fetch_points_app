class Transaction < ApplicationRecord

     #Validations before entering the database
     validates :payer, :points, :timestamp, presence: true

     #Helper class methods for the spend method in the controller

     # Get the total points in the database
     def total
        total_points = 0
        current_points = []
        self.all.map do |t|
            current_points << t.points
        end
        total_points = current_points.sum
     end

     # Substract the points while making sure the transactions' points don't drop to zero
     def substract_points(spend)
        sorted = self.all.sort_by(&:timestamp)
        used_points = {}
        if self.total < spend
            "Not enough points to make the request"
        else
            i = 0
            while i < sorted.length do
                if spend <= 0 
                    break
                end
                if sorted[i].points > 0
                    if spend - sorted[i].points >= 0
                        used_points[sorted[i].payer] = -1 * sorted[i].points
                        spend = spend - sorted[i].points
                        Transaction.update(sorted[i].id, :points => 0)
                    else
                        remaining = sorted[i].points - spend
                        used_points[sorted[i].payer] = -1 * spend
                        spend = 0
                        Transaction.update(sorted[i].id, :points => remaining)
                    end
                else
                    spend = spend - sorted[i].points
                    used_points[sorted[i].payer] = -sorted[i].points
                    Transaction.update(sorted[i].id, :points => 0)
                end
                i+= 1
            end
        end
        used_points
     end

end
