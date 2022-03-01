# Fetch Points App

This is a REST API service used to track payers' points. This is accomplished through 3 end points which allow
the user to check all payers' balances, add transactions for a specific payer and date, and spend(substract) the current points from all payers.

## Setup

To download the dependencies for this web service, run:

```sh
bundle install
```

There is some starter code in the `db/seeds.rb` file so that once you've
generated the models, you'll be able to create data to test the application.

You can run your Rails API on [`localhost:3000`](http://localhost:3000) by running:

```sh
rails s
```

## Use

Once the server is up and running, you can test and check the application by running the Rails server and using a service like Postman to make the requests.

## Models

This app contains the following model:

- A `Transaction`

The the model and migrations are based on the following database table:

![domain diagram](domain.png)

To run the migrations for the model and seed file implement the following :

```sh
rails db:migrate db:seed
```

> If you are not able to get the provided seed file working, you are welcome to
> generate your own seed data to test the application.

## Validations

There are three validations to the `Transaction` model:

- must have a `payer` name that is not nil (has to exist).
- must have an existing `points`. It cannot be nil.
- must have an existing `timestamp` that is not nil.

## Routes

The application contains the following specified routes along with the appropriate HTTP verb.

### GET /current_balances

For all existing recent `Transaction`s created, return JSON data in the format below without repeating payers:

```json
[
  {
    "DANNON": 1000,
    "UNILEVER": 0,
    "MILLER COORS": 5300
  }
]
```

### POST /add_transaction

This route creates a new `Transaction`. It accepts an hash with the following
properties in the body of the request:

```json
{
  "payer": "DANNON",
  "points": 300,
  "timestamp": "2020-10-31T10:00:00Z"
}
```

If the `Transaction` is created successfully, send back a response with the data, along with the appropriate HTTP status code:

```json
{
  "payer": "DANNON",
  "points": 300,
  "timestamp": "2020-10-31T10:00:00Z"
}
```

If the `Transaction` is **not** created successfully, returns the following
JSON data, along with the appropriate HTTP status code:

```json
{
  "errors": ["validation errors"]
}
```

### POST /spend_points

This route substracts a fixed amount of points for every existing payer. It accepts an object with the following property in the body of the request below:

```json
{
  "points": 5000
}
```

If a `Transaction` has a payer that is repeated, it substracts the appropriate points based on the oldest timestamp that exists while ensuring its points do not go below zero.

The expected response from the spend call would be:

```json
[
  { "payer": "DANNON", "points": -100 },
  { "payer": "UNILEVER", "points": -200 },
  { "payer": "MILLER COORS", "points": -4,700 }
]
```

If it is not possible to use the points, the expected response from the call is:

```json
{ "Fatal": "Not enough points to make the request" }
```
