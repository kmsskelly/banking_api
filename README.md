# BankingApi
This project simulates a simple payment API between users, with the possibility of making deposits, withdrawals and transactions.

# Execution

- To run the project you need to have a Postgres container running on port 5432. You can use the docker-compose configuration to ease setting up the environment. 

``` sh
# Run this to have a database on 5432
docker-compose up -d
```
- If you don't want to use docker-compose, you can run:

```sh
 docker run --name banking-api-db -p 5432:5432 -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres -e POSTGRES_DB=banking_api_dev -d postgres
```

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.