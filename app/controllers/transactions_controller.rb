class TransactionsController < ApplicationController

    def index 
        #Variables
        transactions = Transaction.all
        recent_transactions = {}
        #Iterate through all existing hashes in the database and take out the proper attributes from them
        transactions.map do |transaction|
            recent_transactions.key?(transaction.payer) ? recent_transactions[transaction.payer] += transaction.points : recent_transactions[transaction.payer] = transaction.points
        end    
        render json: recent_transactions
    end

    def create
        #Variable with the input params from the request
        new_transaction = Transaction.create(transaction_params)
        #Check whether they are valid or not
        if new_transaction.valid?
            render json: new_transaction, status: 201
        else
            render json: {"errors": new_transaction.errors.full_messages}, status: 422
        end
    end

    def spend
        
    end

    private

    def transaction_params
        params.permit(:payer, :points, :timestamp)
    end
end
