#! /bin/bash
set -x

#基金会帐户 account address: T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S
tafclient wallet importkey --private-key 5KENnPegq7hiPBZYRuuD8x4QonnqErFWz4gMiSGCNEcRvvb4KJE
tafclient new account TAF8VS2tKPTznw8BntttKxGzCR6rupgQYeh8LmKj7dXNAsMZYj8NJ
tafclient transfer tafsys T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S "240000000.0000 TAFT"

#团队帐户 account address: T1BvMyqRo9BnHKi1DamjF1MwWcGT3EGfrCA
tafclient wallet importkey --private-key 5JGdHMeVJc2SpvnY8UPLu4TyxUE3AXQFoxM2pC44hVzvyHKiBYZ
tafclient new account TAF8Gv9KB3M5QmNu69j7BsGXyYQGFAiQWxK9RRmGrCTLuSUQzRE3o
tafclient transfer tafsys T1BvMyqRo9BnHKi1DamjF1MwWcGT3EGfrCA "180000000.0000 TAFT"

#种子轮帐户 account address: T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA
tafclient wallet importkey --private-key 5KLuHULoc5W29ULdtaDUmgG9k29QngNdwKmrqFbQWV2SsKPxtV2
tafclient new account TAF5h8yr8Fuz5XLVcVZL3kYQYaR8bqBJhXK4vFRVG3ThiKDt67Rsw
tafclient transfer tafsys T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA "60000000.0000 TAFT"

#天使轮帐户 account address: T18ZX5kBKHQWjnRfmAg1a69MwYnipZwYEPv
tafclient wallet importkey --private-key 5KJBtxaU5KA3o5u59i2SRANGvh2otv8N6H4zRBWA4mpFLSkJzN3
tafclient new account TAF5icRxEVxJEA6o4GbV5fN9XwkZjMVWaavBNZu7ZX7D2tVWerPmc
tafclient transfer tafsys T18ZX5kBKHQWjnRfmAg1a69MwYnipZwYEPv "84000000.0000 TAFT"

#私募帐户 account address: T1MHkPp5EJ2MhsztVps7MkNaEGa84rWojQp
tafclient wallet importkey --private-key 5K8JvGrUkVDTukZJJmAXYxgjowNrjrxprMNumw1SEvVyjM5xP8W
tafclient new account TAF66VmFxoe3oKMc1yT8CmVaoKXkLTvfnRJVyVuW9L7xwrrYV5XZp
tafclient transfer tafsys T1MHkPp5EJ2MhsztVps7MkNaEGa84rWojQp "360000000.0000 TAFT"

#ICO帐户 account address: T18otnQRXsMjdrMgLWp7XdbXKL8jgJvB3uQ
tafclient wallet importkey --private-key 5Jk71xYbN7spuCyxu34mdMaAiUtEwCjztaqWziK9o4WAHbTNScM
tafclient new account TAF5dAwSsoGDEhG5Gvy58bRoFqKxC5Yj3q33G8HPUY9CUap2U2zrg
tafclient transfer tafsys T18otnQRXsMjdrMgLWp7XdbXKL8jgJvB3uQ "276000000.0000 TAFT"

tafclient tachyon newaccount tafsys --transfer MAKER_LONGNAME_11 TAF8mUftJXepGzdQ2TaCduNuSPAfXJHf22uex4u41ab1EVv9EAhWt --stake-net "100000000.0000 TAFT" --stake-cpu "100000000.0000 TAFT"
tafclient tachyon newaccount tafsys --transfer MAKER_LONGNAME_12 TAF8mUftJXepGzdQ2TaCduNuSPAfXJHf22uex4u41ab1EVv9EAhWt --stake-net "100000000.0000 TAFT" --stake-cpu "100000000.0000 TAFT"
tafclient tachyon newaccount tafsys --transfer MAKER_LONGNAME_13 TAF8mUftJXepGzdQ2TaCduNuSPAfXJHf22uex4u41ab1EVv9EAhWt --stake-net "100000000.0000 TAFT" --stake-cpu "100000000.0000 TAFT"

tafclient maker regmaker MAKER_LONGNAME_11 TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://accountnum11.com
tafclient maker regmaker MAKER_LONGNAME_12 TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://accountnum12.com
tafclient maker regmaker MAKER_LONGNAME_13 TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://accountnum13.com

tafclient maker listmakers

tafclient maker votemakers prods  MAKER_LONGNAME_11 MAKER_LONGNAME_11 MAKER_LONGNAME_12 MAKER_LONGNAME_13

tafclient transfer tafsys MAKER_LONGNAME_11 "9.0000 TAFT"
