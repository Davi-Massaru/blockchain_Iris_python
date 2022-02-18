Class dc.Server Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

ClassMethod mine() As %Status
{
}

ClassMethod newTransaction() As %Status
{
}

ClassMethod chain() As %Status
{
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
    <Route Url="/mine"              Method="GET"    Call="mine" />
    <Route Url="/transactions/new"  Method="POST"   Call="newTransaction" />
    <Route Url="/chain"             Method="GET"    Call="chain" />
</Routes>
}

}
