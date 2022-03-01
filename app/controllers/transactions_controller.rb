class TransactionsController < ApplicationController

    def index 
        #Variables
        transactions = Transaction.all
        recent_transactions = {}
        #Iterate through and take out the proper attributes from all transactions
        transactions.map do |transaction|
            recent_transactions.key?(transaction.payer) ? recent_transactions[transaction.payer] += transaction.points : recent_transactions[transaction.payer] = transaction.points
        end    
        render json: recent_transactions
    end

    private

    def transaction_params
        params.permit(:payer, :points, :timestamp)
    end
end
