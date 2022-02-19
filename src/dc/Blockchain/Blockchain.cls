Class dc.Blockchain.Blockchain Extends %Persistent
{

Property Chain As %SYS.Python;

Property CurrentTransactions As %SYS.Python;

Method %OnNew() As %Status
{
    Do ..createGenesisBlock()
    return $$$OK
}

Method createGenesisBlock() [ Language = python ]
{
    self.Chain = []
    self.CurrentTransactions = []
    self.newBlock("1")
}

Method newBlock(previousHash = "") As %RegisteredObject [ Language = python ]
{
    import time

    block = {
            "index": len(self.Chain) + 1,
            "timestamp": time.time(),
            "transactions": self.CurrentTransactions,
            "previousHash": previousHash or self.Hash(self.LastBlock()),
        }
    
    self.CurrentTransactions = []

    self.Chain.append(block)
    
    return block
}

Method Hash(block) As %String [ Language = python ]
{
    import hashlib
    import json
    block_string = json.dumps(block, sort_keys=True).encode()

    return hashlib.sha256(block_string).hexdigest()
}

Method LastBlock() As %RegisteredObject [ Language = python ]
{
    return self.Chain[-1]
}

Method newTransaction(sender, amount, recipient) As %Integer [ Language = python ]
{
    transaction_fees = 0.00005
    amount_receive_fees = 1 - transaction_fees

    self.CurrentTransactions.append({
        'sender': sender,
        'amount_send': amount,

        'bpsc': 'bpsc_wallet_address',
        'amount_bpsc': amount * transaction_fees,

        'recipient': recipient,
        'amount_receive': amount * amount_receive_fees,
    })

    return self.LastBlock()['index'] + 1
}

ClassMethod InitNewBlockchain()
{
    Set blockchain = ##CLASS(dc.Blockchain.Blockchain).%New()
    Do blockchain.%Save()
    ZW blockchain
}

Storage Default
{
<Data name="BlockchainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Chain</Value>
</Value>
<Value name="3">
<Value>CurrentTransactions</Value>
</Value>
</Data>
<DataLocation>^dc.Blockchain.BlockchainD</DataLocation>
<DefaultData>BlockchainDefaultData</DefaultData>
<IdLocation>^dc.Blockchain.BlockchainD</IdLocation>
<IndexLocation>^dc.Blockchain.BlockchainI</IndexLocation>
<StreamLocation>^dc.Blockchain.BlockchainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
