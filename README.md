# HttpcBench

An Elixir port of [lpgauth's Erlang HTTP client
benchmarks](https://github.com/lpgauth/httpc_bench).

## Configuration

Add the desired clients and versions to `mix.exs`.

Configuration is done in `config/config.exs`.  There, you can set the
output format (`:text`, `:csv`, or `:html`), running conditions
(concurrencies, pool sizes, etc), and destination (URL, hostname, port, path)
in `config.exs`.

A path like `/wait/10` will wait 10 ms before returning.

## Running

`mix run_server` runs the test server.

`mix run_clients [output-format]` runs the clients and emits benchmark
information to stdout in the specified format: `text` (default), `html`,
or `csv`.

## Building on Ubuntu 18.04

```bash
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get -y update
sudo apt-get -y install esl-erlang elixir build-essential zlib1g-dev
mix local.hex
mix local.rebar
git clone https://github.com/gamache/httpc_bench.git
cd httpc_bench
mix deps.get
mix compile
CFLAGS='-stc=c11' mix compile
mix compile
```
## Terraform
See all variables in `terraform/variables.tf`.
Copy `terraform/my-vars.tfvars.example` to `terraform/my-vars.tfvars` and populate the variables.

```bash
cd terraform
terraform init
terraform apply --var-file=my-vars.tfvars
```

After terraform completes the server's public ip addresses will be output for you.

Ssh to the server and run:
```
cd httpc_bench
MIX_ENV=prod iex -S mix
iex> HttpcBench.run_server()
```
(TODO: ^ not ideal, we can get the server to start automatically after the installation is complete)

Next ssh to the client and run:
```
cd httpc_bench
MIX_ENV=prod mix run_clients
```
