xmlport 50007 "Import Time Table"
{

    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(TT; "Time Table")
            {
                AutoUpdate = true;
                XmlName = 'TT';
                fieldattribute(NodeName11; TT."Campus Code") { }
                fieldattribute(NodeName2; TT.Semester) { }
                fieldattribute(NodeName3; TT.Unit) { }
                fieldattribute(NodeName4; TT."Day of Week") { }
                fieldattribute(NodeName5; TT.Period) { }
                fieldattribute(NodeName6; TT."Unit Class") { }
                fieldattribute(NodeName7; TT."Lecture Room") { }
                fieldattribute(NodeName8; TT.Lecturer) { }
                fieldattribute(NodeName9; TT."Mode of Study") { }
                fieldattribute(NodeName10; TT."Class Size") { }
            }
        }


    }
}