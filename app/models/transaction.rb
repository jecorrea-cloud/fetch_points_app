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
     def substract_points(spending_pts)
        # Sort all transactions by recent date
        sorted_trans = self.all.sort_by(&:timestamp)
        # Hash to return balances
        used_points = {}
        # Conditional. If the total points are not enough to be spent, return a message
        if self.total < spending_pts
            {"Fatal": "Not enough points to make the request"}
        else
            # Otherwise, iterate through if there are enough points in the database
            for i in 0...sorted_trans.length do
                # If the input points happen to be zero, exit
                if spending_pts <= 0 
                    break
                end
                # Check if the current transaction's balance is not 0
                if sorted_trans[i].points > 0
                    # Case when the substraction is positive (input points are greater than balance points)
                    if spending_pts - sorted_trans[i].points >= 0
                        used_points[sorted_trans[i].payer] = -1 * sorted_trans[i].points
                        spending_pts = spending_pts - sorted_trans[i].points
                        Transaction.update(sorted_trans[i].id, :points => 0)
                    # Case when the substraction is negative (input points are less than balance points)
                    else
                        remaining = sorted_trans[i].points - spending_pts
                        used_points[sorted_trans[i].payer] = -1 * spending_pts
                        spending_pts = 0
                        Transaction.update(sorted_trans[i].id, :points => remaining)
                    end
                # Otherwise, substract 0
                else
                    spending_pts = spending_pts - sorted_trans[i].points
                    used_points[sorted_trans[i].payer] = -sorted_trans[i].points
                    Transaction.update(sorted_trans[i].id, :points => 0)
                end
            end
        end
        used_points
     end

end
