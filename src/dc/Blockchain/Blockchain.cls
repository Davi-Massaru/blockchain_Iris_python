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

Method newBlock(previousHash) As %RegisteredObject [ Language = python ]
{
    import time

    block = {
            "index": len(self.Chain) + 1,
            "timestamp": time.time(),
            "transactions": self.CurrentTransactions,
            "previousHash": previousHash or self.Hash(self.Chain[-1]),
        }
    
    self.CurrentTransactions = []

    self.Chain.append(block)
    
    return block
}

Method Hash(block) As %String [ Language = python ]
{
    import hashlib

    block_string = json.dumps(block, sort_keys=True).encode()
    return hashlib.sha256(block_string).hexdigest()
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
