Class dc.pythonHelper [ Language = python ]
{

ClassMethod pythonObjToString(obj) As %String
{
    import json
    return json.dumps(obj)
}

}
