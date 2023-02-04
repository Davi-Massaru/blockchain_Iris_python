Class dc.UserTest Extends dc.PersistenLogAbstract
{

Property Name As %String;

Property Age As %Integer;

Storage Default
{
<Data name="UserTestDefaultData">
<Subscript>"UserTest"</Subscript>
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Age</Value>
</Value>
<Value name="3">
<Value>HasChildren</Value>
</Value>
</Data>
<DefaultData>UserTestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
