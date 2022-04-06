#! /bin/bash
set -x

cleos --url http://127.0.0.1:8889/ system newaccount eosio --transfer accountnum11 EOS8mUftJXepGzdQ2TaCduNuSPAfXJHf22uex4u41ab1EVv9EAhWt --stake-net "100000000.0000 EOS" --stake-cpu "100000000.0000 EOS" --buy-ram-kbytes 8
cleos --url http://127.0.0.1:8889/ system newaccount eosio --transfer accountnum12 EOS8mUftJXepGzdQ2TaCduNuSPAfXJHf22uex4u41ab1EVv9EAhWt --stake-net "100000000.0000 EOS" --stake-cpu "100000000.0000 EOS" --buy-ram-kbytes 8
cleos --url http://127.0.0.1:8889/ system newaccount eosio --transfer accountnum13 EOS8mUftJXepGzdQ2TaCduNuSPAfXJHf22uex4u41ab1EVv9EAhWt --stake-net "100000000.0000 EOS" --stake-cpu "100000000.0000 EOS" --buy-ram-kbytes 8

cleos --url http://127.0.0.1:8889/ system regproducer accountnum11 EOS5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://accountnum11.com
cleos --url http://127.0.0.1:8889/ system regproducer accountnum12 EOS5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://accountnum12.com
cleos --url http://127.0.0.1:8889/ system regproducer accountnum13 EOS5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://accountnum13.com

cleos --url http://127.0.0.1:8889/ system listproducers

cleos --url http://127.0.0.1:8889/ system voteproducer prods accountnum11 accountnum11 accountnum12 accountnum13

cleos --url http://127.0.0.1:8889/ transfer eosio accountnum11 "9.0000 EOS"
cleos --url http://127.0.0.1:8889/ get info
