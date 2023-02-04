Class dc.PersistenLogAbstract Extends (%Persistent, %JSON.Adaptor) [ Abstract ]
{

Method %OnAfterSave() As %Status
{
    do $THIS.%JSONExportToString(.jsonContent)
    Do ..createBlockLog(jsonContent, $THIS.%ClassName(1), ..%Id())
    return ..%OnAfterSaveLog()
}

Method %OnAfterSaveLog() As %Status
{
    return $$$OK
}

Method createBlockLog(content, classNameObj As %String, id As %String) [ Language = python ]
{
    import iris
    import time
    import json

    GBlockchain = iris.gref('GBlockchainLog')

    if (GBlockchain[classNameObj, id] == None) :
        index = 0
    else:
        index = GBlockchain[classNameObj, id] + 1

    previousHash = '' if (index == 0) else GBlockchain[classNameObj, id, index-1, 'hash']
    block = {
            'index': index,
            'timestamp': time.time(),
            'stack':  self.getStack(),
            'content':  json.dumps(content),
            'previousHash': previousHash
    }

    block['hash'], block['nonce'] =  self.FindHashNonceBlock(block, previousHash, 1) 

    GBlockchain[classNameObj, id] = index
    GBlockchain[classNameObj, id, index, 'index'] = block['index']
    GBlockchain[classNameObj, id, index, 'stack'] = block['stack']
    GBlockchain[classNameObj, id, index, 'block'] = json.dumps(block)
    GBlockchain[classNameObj, id, index, 'timestamp'] = block['timestamp']
    GBlockchain[classNameObj, id, index, 'previousHash'] = block['previousHash']
    GBlockchain[classNameObj, id, index, 'hash'] = block['hash']
    GBlockchain[classNameObj, id, index, 'nonce'] = block['nonce']
}

Method FindHashNonceBlock(block, hash = "", nonce = 1) As %String [ Language = python ]
{
    import hashlib
    import json

    index = block['index']
    timestamp = block['timestamp']
    stack = block['stack']
    content = block['content']
    previousHash = block['previousHash']

    while not self.isHashValid(hash):

        block_string = '{}:{}:{}:{}:{}:{}'.format(index,timestamp,stack, content, previousHash, nonce)
        
        hash = hashlib.sha256(block_string.encode()).hexdigest()
        nonce += 1
    return hash, nonce
}

Method isHashValid(hash) As %Boolean [ Language = python ]
{
    return hash.startswith('000')
}

ClassMethod getStack() As %String
{
	Set stack = ""
	Set lengthStack = $STACK
	For contextStack=1:1:lengthStack{
		Set $LIST(stack,*+1) = $ZSTRIP($STACK(contextStack,"PLACE"),"<>W")
	}
	Return $LISTTOSTRING(stack,$CHAR(13,10))
}

Storage Default
{
<Data name="PersistenLogAbstractDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LastUpdate</Value>
</Value>
</Data>
<DataLocation>^dc.PersistenLogAbstractD</DataLocation>
<DefaultData>PersistenLogAbstractDefaultData</DefaultData>
<IdLocation>^dc.PersistenLogAbstractD</IdLocation>
<IndexLocation>^dc.PersistenLogAbstractI</IndexLocation>
<StreamLocation>^dc.PersistenLogAbstractS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
