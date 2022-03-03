class TransactionsController < ApplicationController

    def current_balances 
        #Bring down all present transactions in the database
        transactions = Transaction.all
        recent_transactions = {}
        #Iterate through all existing hashes in the database and take out the proper attributes from them
        transactions.map do |transaction|
            recent_transactions.key?(transaction.payer) ? recent_transactions[transaction.payer] += transaction.points : recent_transactions[transaction.payer] = transaction.points
        end    
        render json: recent_transactions
    end

    def create_transactions
        #Variable with the input params from the request
        new_transaction = Transaction.create(transaction_params)
        #Check whether they are valid or not. If they are, return the object just created and the status or error messages
        if new_transaction.valid?
            render json: new_transaction, status: 201
        else
            render json: {"errors": new_transaction.errors.full_messages}, status: 422
        end
    end

    def spend_pts
        #Call on the class helper method to substract points and return balances
        spent = Transaction.substract_points(transaction_params[:points].to_i)
        render json: spent, status: 201
    end

    private

    def transaction_params
        params.permit(:payer, :points, :timestamp)
    end
end
