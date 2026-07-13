Table 50515 "PR Bank Branches"
{
    DrillDownPageID = "PR Bank Branches";
    DataCaptionFields = "Bank Code", "Branch Code", "Bank Name";
    LookupPageID = "PR Bank Branches";

    fields
    {
        field(1; "Branch Code"; Code[10]) { }
        field(2; "Branch Name"; Text[100]) { }
        field(3; "Bank Code"; Code[10])
        {
            TableRelation = "PR Bank Accounts"."Bank Code";
        }
        field(4; "Bank Name"; Text[100])
        {
            CalcFormula = lookup("PR Bank Accounts"."Bank Name" where("Bank Code" = field("Bank Code")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Branch Code", "Bank Code")
        {
            Clustered = true;
        }
        key(Key2; "Branch Name") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Branch Code", "Branch Name") { }
    }
}

