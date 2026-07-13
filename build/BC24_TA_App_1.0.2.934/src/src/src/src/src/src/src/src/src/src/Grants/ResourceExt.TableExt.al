tableextension 50016 "Resource Ext" extends Resource
{
    fields
    {
        field(70134671; "Employee No"; code[20]) { }
        field(70134672; "Email"; text[200]) { }
        field(70134673; Telephone; code[80]) { }
        field(70134674; Institution; Option)
        {
            OptionMembers = ,Main,Sub,Others;
        }
        field(70134675; "User ID"; code[20]) { }
    }
}