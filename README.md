## blockchain IRIS - ( Embedded Python )

Example of creating a financial blockchain Using Embedded Python on IRIS Data Platform

## What is a blockchain

Blockchain is a chain of blocks, where each block contains information from the previous block, this concept can be applied in many ways.

## What is a blocks?

Block will be composed of: a datetime, index, content, hash and the hash of the previous block.

In this project the blocks are constructed by:

1. index:
    - block identification index in the chain 
2. timestamp:
    - block creation datetime 
3. transactions:
    - Financial transactions that are part of this block, represents the content of the block, you can change the structure by changing the dc.Blockchain.Blockchain classmethod newTransaction
4. hash:
    - the entire contents of the encrypted block
5. nonce:
    - value that the system finds by the mining process, changing the hash value when the block is generated.
6. previousHash:
    - hash of the previous block

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/Davi-Massaru/blockchain_Iris_python.git
```

Open the terminal in this directory and run:

```
$ docker-compose build && docker-compose up -d
```

Run the endpoint ```curl http://localhost:52773/api/blockchain/ping``` to verify the connection to the server

## Get Started

After installing the application, you can access the end-points to better understand how it works

1. http://localhost:52773/api/blockchain/1/full [ GET ]

Returns the current state of the blockchain and transactions that are waiting to be added to a block

Response sample:
```
{
	"Chain": [
		{
			"index": 1,
			"timestamp": 1645393935.0290358,
			"transactions": [],
			"previousHash": "000",
			"hash": "000",
			"nonce": 1
		}
	],
	"CurrentTransactions": [
		{
			"sender": "user 1",
			"amount_send": 1.42,
			"bpsc": "bpsc_wallet_address",
			"amount_bpsc": 7.1e-05,
			"recipient": "user 2",
			"amount_receive": 1.419929
		}
	]
}
```

2. http://localhost:52773/api/blockchain/1/transactions/new [ POST ]

Add a new transaction to be computed in a block, and return which block the transaction will be added

Request Content:
```
{
	"sender": "user 1",
	"amount": 1.42,
	"recipient": "user 2"
}
```

Response sample:
```
{
	"message": "Transaction will be added to Block 2"
}
```

3. http://localhost:52773/api/blockchain/1/mine [ GET ]

Start mining a new block that will be added to the chain, returns added block information

Response sample:
```
{
	"message": "New Block Forged",
	"index": 2,
	"timestamp": 1645395071.726108074,
	"transactions": "[{\"sender\": \"user 1\", \"amount_send\": 1.42, \"bpsc\": \"bpsc_wallet_address\", \"amount_bpsc\": 7.1e-05, \"recipient\": \"user 2\", \"amount_receive\": 1.419929}]",
	"previousHash": "000"
}
```

4. http://localhost:52773/api/blockchain/1/chain [ GET ]

Returns the current state of blockchain

```
{
	"chain": [
		{
			"index": 1,
			"timestamp": 1645393935.0290358,
			"transactions": [],
			"previousHash": "000",
			"hash": "000",
			"nonce": 1
		},
		{
			"index": 2,
			"timestamp": 1645395071.726108,
			"transactions": [
				{
					"sender": "user 1",
					"amount_send": 1.42,
					"bpsc": "bpsc_wallet_address",
					"amount_bpsc": 7.1e-05,
					"recipient": "user 2",
					"amount_receive": 1.419929
				}
			],
			"previousHash": "000",
			"hash": "000b853ef889e52b56a876e2de8de233c1401fcebde2fc0f8c6dcbe95002514c",
			"nonce": 4637
		}
	],
	"length": 2
}
```

## References:
- https://python.plainenglish.io/implementing-a-smart-blockchain-with-python-3183e0c1052e
- https://www.activestate.com/blog/how-to-build-a-blockchain-in-python/
- https://geekflare.com/create-a-blockchain-with-python/