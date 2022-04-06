#! /bin/bash
set -x

#基金会帐户 account address: T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S
tafclient wallet importkey --private-key 5KENnPegq7hiPBZYRuuD8x4QonnqErFWz4gMiSGCNEcRvvb4KJE
tafclient new account TAF8VS2tKPTznw8BntttKxGzCR6rupgQYeh8LmKj7dXNAsMZYj8NJ
tafclient transfer T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S "240000000.0000 TAFT"
AccountFoundation="T17Y2vaQtyQmGVm3MZrvS3hGFj5zVXvo48S"

#团队帐户 account address: T1BvMyqRo9BnHKi1DamjF1MwWcGT3EGfrCA
tafclient wallet importkey --private-key 5JGdHMeVJc2SpvnY8UPLu4TyxUE3AXQFoxM2pC44hVzvyHKiBYZ
tafclient new account TAF8Gv9KB3M5QmNu69j7BsGXyYQGFAiQWxK9RRmGrCTLuSUQzRE3o
tafclient transfer T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1BvMyqRo9BnHKi1DamjF1MwWcGT3EGfrCA "180000000.0000 TAFT"

#投资者帐户 account address: T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA
tafclient wallet importkey --private-key 5KLuHULoc5W29ULdtaDUmgG9k29QngNdwKmrqFbQWV2SsKPxtV2
tafclient new account TAF5h8yr8Fuz5XLVcVZL3kYQYaR8bqBJhXK4vFRVG3ThiKDt67Rsw
tafclient transfer T1HHsxQ3igveVAfbXipkWH89J6VFS5QGF6T T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA "780000000.0000 TAFT"
AccountInvestor="T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA"

#给tafbas抵压cpu和net，保证创建帐户命令得到正确执行
tafclient maker delegatesource T1FwoGPJdMdCaBxiXXJYuQHQs1MnRzT9vTA T17pFoCekTq9Ukui6jgFhu2QLc9F5tMvJif "500 TAFT" "500 TAFT"

#Private key: 5JuKyGxvMmQF9HuZjsuRcCChow81MQwWQrfwsdv4MmqBXKFg4gZ
#Public key: TAF7busyMdrh7xdxCZezMsatdFu5J6zG9eQ1eD97h7AmNZphnKWcU
tafclient wallet importkey --private-key 5JuKyGxvMmQF9HuZjsuRcCChow81MQwWQrfwsdv4MmqBXKFg4gZ

#Private key: 5JzTRMQ82igs7fT5zDuJWXagTpS3RRdEas53PRTDNUm7CHFoJPa
#Public key: TAF5fgrWNJ1PyMqbkWvdjrn4Mww5NrZ2pYqC1gzMGZcevHgm6PEKr
tafclient wallet importkey --private-key 5JzTRMQ82igs7fT5zDuJWXagTpS3RRdEas53PRTDNUm7CHFoJPa

#Private key: 5JjHW9MBNS5x7aiEccGR81X5eYrNPeE4XMaAWWDYNHgrfqUnhy1
#Public key: TAF6S1renum7v667hmwe6yYbUaTBba1QDyDCK5Z7GNMxpYcFxsyti
tafclient wallet importkey --private-key 5JjHW9MBNS5x7aiEccGR81X5eYrNPeE4XMaAWWDYNHgrfqUnhy1

#account address: T17VzCrQddyUgzWhEk9AKykPhPZrEDW4ktV
tafclient new account TAF7busyMdrh7xdxCZezMsatdFu5J6zG9eQ1eD97h7AmNZphnKWcU
#account address: T1P2cD7cBXo4fTyANmjwjwCjvoSThCHp9ma
tafclient new account TAF5fgrWNJ1PyMqbkWvdjrn4Mww5NrZ2pYqC1gzMGZcevHgm6PEKr
#account address: T12c7HZkYAfrWZYZ4EnoXfs3ukyMNyHiQSE
tafclient new account TAF6S1renum7v667hmwe6yYbUaTBba1QDyDCK5Z7GNMxpYcFxsyti

tafclient transfer $AccountInvestor T17VzCrQddyUgzWhEk9AKykPhPZrEDW4ktV "200000000.0000 TAFT"
tafclient transfer $AccountInvestor T1P2cD7cBXo4fTyANmjwjwCjvoSThCHp9ma "100.0000 TAFT"
tafclient transfer $AccountInvestor T12c7HZkYAfrWZYZ4EnoXfs3ukyMNyHiQSE "100.0000 TAFT"

tafclient maker delegatesource T17VzCrQddyUgzWhEk9AKykPhPZrEDW4ktV T17VzCrQddyUgzWhEk9AKykPhPZrEDW4ktV "100000000.0000 TAFT" "100000000.0000 TAFT"
tafclient maker delegatesource T1P2cD7cBXo4fTyANmjwjwCjvoSThCHp9ma T1P2cD7cBXo4fTyANmjwjwCjvoSThCHp9ma "50.0000 TAFT" "50.0000 TAFT"
tafclient maker delegatesource T12c7HZkYAfrWZYZ4EnoXfs3ukyMNyHiQSE T12c7HZkYAfrWZYZ4EnoXfs3ukyMNyHiQSE "50.0000 TAFT" "50.0000 TAFT"

tafclient maker regmaker T17VzCrQddyUgzWhEk9AKykPhPZrEDW4ktV TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://accountnum11.com
tafclient maker regmaker T1P2cD7cBXo4fTyANmjwjwCjvoSThCHp9ma TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://accountnum12.com
tafclient maker regmaker T12c7HZkYAfrWZYZ4EnoXfs3ukyMNyHiQSE TAF5EfU2fDgHZTNwPhuoHJgKcrNJ3PbyaYMHMrgMnBpVffWjgeJjX https://accountnum13.com

tafclient maker listmakers

tafclient maker votemakers prods  T17VzCrQddyUgzWhEk9AKykPhPZrEDW4ktV T17VzCrQddyUgzWhEk9AKykPhPZrEDW4ktV T1P2cD7cBXo4fTyANmjwjwCjvoSThCHp9ma T12c7HZkYAfrWZYZ4EnoXfs3ukyMNyHiQSE

tafclient maker listmakers

