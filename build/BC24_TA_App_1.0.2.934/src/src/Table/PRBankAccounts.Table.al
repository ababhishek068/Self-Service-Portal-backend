Table 50514 "PR Bank Accounts"
{
    DrillDownPageID = "PR Bank Accounts";
    LookupPageID = "PR Bank Accounts";
    DataCaptionFields = "Bank Code", "Bank Name";

    fields
    {
        field(1; "Bank Code"; Code[20]) { }
        field(2; "Bank Name"; Text[100]) { }
        field(3; "Bank Type"; Option)
        {
            OptionMembers = Bank,Sacco;
        }
        field(5;"Minimum Digits";Integer){}
        field(6;"Maximu Digits";Integer){}
        field(7;"Favourite Rank";Integer){}
    }

    keys
    {
        key(Key1; "Bank Code","Favourite Rank")
        {
            Clustered = true;
        }
        key(Key2; "Bank Name") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Bank Code", "Bank Name") { }
    }
}

