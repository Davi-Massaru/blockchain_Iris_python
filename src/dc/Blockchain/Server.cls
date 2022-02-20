Class dc.Blockchain.Server Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

ClassMethod mine(idBlockchain As %Integer) As %Status
{
    Set blockchain = ##CLASS(dc.Blockchain.Blockchain).%OpenId(idBlockchain)
    Do blockchain.Mine()
    return $$$OK
}

ClassMethod newTransaction() As %Status
{
}

ClassMethod Chain(idBlockchain As %Integer) As %Status
{
    Set blockchain = ##CLASS(dc.Blockchain.Blockchain).%OpenId(idBlockchain)
    Set a = blockchain.ViewChain()
    zw a.chain
    return $$$OK
}

ClassMethod ping() As %Status
{
    Write { "Say" : "Pong" }.%ToJSON()
    Return $$$OK
}

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/ping"              Method="GET"    Call="ping" />
    <Route Url="/mine/:idBlockchain"              Method="GET"    Call="mine" />
    <Route Url="/transactions/new"  Method="POST"   Call="newTransaction" />
    <Route Url="/:idBlockchain/chain"              Method="GET"    Call="Chain" />
</Routes>
}

}
