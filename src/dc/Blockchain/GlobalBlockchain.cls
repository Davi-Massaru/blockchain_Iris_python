Class dc.Blockchain.GlobalBlockchain Extends %RegisteredObject [ Language = python ]
{

Method createGenesisBlock()
{
    import iris
    GBlockchain = iris.gref('GBlockchain')
    GTransactions = iris.gref('GTransactions')

    GBlockchain[None] = 0
    GTransactions[1] ="[]"

    self.newBlock("000")
}

Method newBlock(previousHash = "") As %SYS.Python
{
   
    import iris
    import time
    import json

    GBlockchain = iris.gref('GBlockchain')
    GTransactions = iris.gref('GTransactions')

    index = GBlockchain[None] + 1

    block = {
            'index': index,
            'timestamp': time.time(),
            'transactions': json.loads(GTransactions[index]) if GTransactions[index]  is not None else [],
            'previousHash': previousHash if GBlockchain[None] == 0 else GBlockchain[index-1,'hash']
    }

    block['hash'], block['nonce'] =  self.Hash(block, previousHash, 1) 

    GBlockchain[None] = index
    GBlockchain[index] = block['index']
    GBlockchain[index, 'block'] = json.dumps(block)
    GBlockchain[index,'timestamp'] = block['timestamp']
    GBlockchain[index,'transactions'] = json.dumps(block['transactions'])
    GBlockchain[index,'previousHash'] = block['previousHash']
    GBlockchain[index,'hash'] = block['hash']
    GBlockchain[index,'nonce'] = block['nonce']

    return block
}

Method Hash(block, hash = "", nonce = 1) As %String
{
    import hashlib
    import json

    index = block['index']
    timestamp = block['timestamp']
    transactions = block['transactions']
    previousHash = block['previousHash']

    while not self.isHashValid(hash):

        block_string = '{}:{}:{}:{}:{}'.format(index, timestamp, transactions, previousHash, nonce)
        
        hash = hashlib.sha256(block_string.encode()).hexdigest()
        nonce += 1
    
    return hash, nonce
}

Method isHashValid(hash) As %Boolean
{
    return hash.startswith('000')
}

Method newTransaction(sender, amount, recipient) As %Integer
{
    import iris
    import json
    
    GBlockchain = iris.gref('GBlockchain')
    GTransactions = iris.gref('GTransactions')
    
    idx_transaction = GBlockchain[None] + 1

    GTransactionsList = json.loads(GTransactions[idx_transaction]) if GTransactions[idx_transaction]  is not None else []
    GTransactionsList.append({
        'sender': sender,
        'amount': amount,
        'recipient': recipient,
    })

    GTransactions[idx_transaction] = json.dumps(GTransactionsList)

    return idx_transaction
}

Method chain()
{
    import iris
    import json

    GBlockchain = iris.gref('GBlockchain')

    chain = []
    for index_block in range(GBlockchain[None]):
        chain.append( json.loads(GBlockchain[index_block + 1, 'block']) )
    
    return json.dumps(chain)
}

Method getBlock(index)
{
    import iris
    GBlockchain = iris.gref('GBlockchain')
    return GBlockchain[index, 'block']
}

}
