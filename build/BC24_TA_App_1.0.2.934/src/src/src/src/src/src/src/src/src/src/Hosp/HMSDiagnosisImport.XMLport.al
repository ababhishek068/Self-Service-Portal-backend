XmlPort 50000 "HMS Diagnosis Import"
{

    schema
    {
        tableelement("HMS Setup Diagnosis"; "HMS Setup Diagnosis")
        {
            XmlName = 'Diagnosis_Import';
            fieldelement(Code; "HMS Setup Diagnosis".Code) { }
            fieldelement(Description; "HMS Setup Diagnosis".Description) { }
            fieldelement(Diagnosis; "HMS Setup Diagnosis".Diagnosis) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }
}

