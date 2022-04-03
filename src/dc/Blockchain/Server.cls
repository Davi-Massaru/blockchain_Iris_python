Class dc.Blockchain.Server Extends dc.REST.Base
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

ClassMethod mine() As %Status
{
    Set blockchain = ##CLASS(dc.Blockchain.GlobalBlockchain).%New()
    Set block = blockchain.newBlock()

    set idxBlock = block."__getitem__"("index")

    Write {
        "message": "New Block Forged",
        "index": (idxBlock),
        "timestamp": (^GBlockchain(idxBlock,"timestamp")),
        "transactions": (^GBlockchain(idxBlock,"transactions")),
        "hash": (^GBlockchain(idxBlock,"hash")),
        "previousHash":(^GBlockchain(idxBlock,"previousHash"))
    }.%ToJSON()
    
    Return $$$OK
}

ClassMethod newTransaction() As %Status
{
    Set data = %request.Content
    Set blockchain = ##CLASS(dc.Blockchain.GlobalBlockchain).%New()
    Set index = blockchain.newTransaction(data.sender, data.amount, data.recipient)
    
    Write {"message": ("Transaction will be added to Block "_index) }.%ToJSON()

    Return $$$OK
}

ClassMethod chain() As %Status
{
    Set blockchain = ##CLASS(dc.Blockchain.GlobalBlockchain).%New()
    Write blockchain.chain()

    Return $$$OK
}

ClassMethod getBlock(index) As %Status
{
    Set blockchain = ##CLASS(dc.Blockchain.GlobalBlockchain).%New()
    Write blockchain.getBlock(index)
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
    <Route Url="/ping"                Method="GET"    Call="ping"             Cors="true"/>
    <Route Url="/mine"                Method="GET"    Call="mine"             Cors="true"/>
    <Route Url="/transactions/new"    Method="POST"   Call="newTransaction"   Cors="true"/>
    <Route Url="/chain"               Method="GET"    Call="chain"             Cors="true"/>
    <Route Url="/block/:index"        Method="GET"    Call="getBlock"             Cors="true"/>
</Routes>
}

}
