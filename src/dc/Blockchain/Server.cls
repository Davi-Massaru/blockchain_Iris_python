Class dc.Blockchain.Server Extends dc.REST.Base
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

ClassMethod mine(idBlockchain As %Integer) As %Status
{
    Set blockchain = ##CLASS(dc.Blockchain.Blockchain).%OpenId(idBlockchain)

    Set lastBlock = blockchain.LastBlock()
    Set previousHash = blockchain.Hash(lastBlock)
    Set block = blockchain.newBlock(previousHash)

    Do blockchain.%Save()
    
    Write {
        "message": "New Block Forged",
        "index": (block."__getitem__"("index")),
        "timestamp": (block."__getitem__"("timestamp")),
        "transactions": (##CLASS(dc.pythonHelper).pythonObjToString( block."__getitem__"("transactions"))),
        "previousHash": (block."__getitem__"("previousHash"))
    }.%ToJSON()
    
    Return $$$OK
}

ClassMethod newTransaction(idBlockchain As %Integer) As %Status
{
    Set data = %request.Content
    Set blockchain = ##CLASS(dc.Blockchain.Blockchain).%OpenId(idBlockchain)
    Set index = blockchain.newTransaction(data.sender, data.amount, data.recipient)
    Do blockchain.%Save()
    
    Write {"message": ("Transaction will be added to Block "_index) }.%ToJSON()

    Return $$$OK
}

ClassMethod chain(idBlockchain As %Integer) As %Status
{
    Set blockchain = ##CLASS(dc.Blockchain.Blockchain).%OpenId(idBlockchain)
    Write ##CLASS(dc.pythonHelper).pythonObjToString(blockchain.ViewChain())

    Return $$$OK
}

ClassMethod full(idBlockchain As %Integer) As %Status
{
    Set blockchain = ##CLASS(dc.Blockchain.Blockchain).%OpenId(idBlockchain)

    Write blockchain.ToString()

    Return $$$OK
}

ClassMethod ping() As %Status
{
    Write { "Say" : "Pong" }.%ToJSON()
    Return $$$OK
}

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/ping"                  Method="GET"    Call="ping" Cors="true"/>
    <Route Url="/:idBlockchain/mine"    Method="GET"    Call="mine" Cors="true"/>
    <Route Url="/:idBlockchain/transactions/new"      Method="POST"   Call="newTransaction" Cors="true"/>
    <Route Url="/:idBlockchain/chain"   Method="GET"    Call="chain" Cors="true"/>
    <Route Url="/:idBlockchain/full"   Method="GET"    Call="full" Cors="true"/>
</Routes>
}

}
