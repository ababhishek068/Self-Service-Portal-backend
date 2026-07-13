Table 50895 "CshMgt PV Steps Users"
{
    //  DrillDownPageID = UnknownPage70135123;
    // LookupPageID = UnknownPage70135123;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Description = 'Stores the code reference to the step in the database';
            TableRelation = "CshMgt PV Steps".Code;
        }
        field(2; Description; Text[30])
        {
            Description = 'Stores the description of teh step in the database';
        }
        field(3; UserID; Code[20])
        {

            trigger OnLookup()
            begin
                // LoginMgt.LookupUserID(UserID);

                Validate(UserID);
            end;

            trigger OnValidate()
            begin
                //  LoginMgt.ValidateUserID(UserID);
                User.Reset;
                User.Get(Rec.UserID);
                Rec."User name" := User."User Name";
            end;
        }
        field(4; "User name"; Text[30]) { }
        field(5; Email; Text[30]) { }
        field(6; "Email Alert ?"; Boolean) { }
        field(7; "No."; Boolean) { }
        field(8; Date; Boolean) { }
        field(9; "Global Dimension 1 Code"; Boolean)
        {
            CaptionClass = '1,2,1';
        }
        field(10; "Global Dimension 2 Code"; Boolean)
        {
            CaptionClass = '1,2,2';
        }
        field(11; "Paying Bank Account"; Boolean) { }
        field(12; "Payment To"; Boolean) { }
        field(13; "On Behalf Of"; Boolean) { }
        field(14; PVLines; Boolean) { }
    }

    keys
    {
        key(Key1; "Code", UserID)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        User: Record User;
}

