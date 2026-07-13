Table 50397 "Closeout Checklist Lines"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Closeout Nos"; Code[50])
        {
            TableRelation = "Close Out Check List"."Closeout No.";
        }
        field(3; Sections; Code[250]) { }
        field(4; Options; Option)
        {
            OptionCaption = 'Not Applicable,Submitted,Submitted (Copy Attached),Submitted(Original Attached),Not Submited,No Equipment Purchased,None,Already Returned,Enclosed';
            OptionMembers = "Not Applicable",Submitted,"Submitted (Copy Attached)","Submitted(Original Attached)","Not Submited","No Equipment Purchased","None","Already Returned",Enclosed;
        }
        field(5; Amount; Decimal) { }
        field(6; Reason; Text[250]) { }
    }

    keys
    {
        key(Key1; "Line No", "Closeout Nos")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

