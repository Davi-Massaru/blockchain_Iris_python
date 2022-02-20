Class dc.Blockchain.Blockchain Extends %Persistent [ Language = python ]
{

Property Chain As %String;

Property CurrentTransactions As %String;

Method %OnNew() As %Status [ Language = objectscript ]
{
    Do ..createGenesisBlock()
    return $$$OK
}

Method %OnOpen() As %Status
{
    import json
    import iris
    
    self.Chain = json.loads(self.Chain)
    self.CurrentTransactions = json.loads(self.CurrentTransactions)

    return iris.cls("%SYSTEM.Status").OK()
}

Method %OnBeforeSave(insert As %Boolean) As %Status
{
    import json
    import iris

    self.Chain = json.dumps(self.Chain)
    self.CurrentTransactions = json.dumps(self.CurrentTransactions)

    return iris.cls("%SYSTEM.Status").OK()
}

Method %OnAfterSave(insert As %Boolean) As %Status
{
    import json
    import iris

    self.Chain = json.loads(self.Chain)
    self.CurrentTransactions = json.loads(self.CurrentTransactions)

    return iris.cls("%SYSTEM.Status").OK()
}

Method createGenesisBlock()
{
    self.Chain = []
    self.CurrentTransactions = []
    self.newBlock("1")
}

Method newBlock(previousHash = "")
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

Method Hash(block) As %String
{
    import hashlib
    import json
    block_string = json.dumps(block, sort_keys=True).encode()

    return hashlib.sha256(block_string).hexdigest()
}

Method LastBlock()
{
    return self.Chain[-1]
}

Method newTransaction(sender, amount, recipient) As %Integer
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

Method ViewChain()
{
    return {
        'chain': self.Chain,
        'length': len(self.Chain)
    }
}

Method ToString() As %String
{
    import json

    data = {
        'Chain' : self.Chain,
        'CurrentTransactions' : self.CurrentTransactions
    }

    return json.dumps(data)
}

ClassMethod InitNewBlockchain() [ Language = objectscript ]
{
    Set blockchain = ##class(dc.Blockchain.Blockchain).%New()
    W "CREATE blockchain Persistent Class:"_blockchain.%Save()
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
