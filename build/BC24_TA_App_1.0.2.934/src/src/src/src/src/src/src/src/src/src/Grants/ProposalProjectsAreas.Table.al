Table 50393 "Proposal/Projects Areas"
{
    //  DrillDownPageID = UnknownPage70134739;
    // LookupPageID = UnknownPage70134739;

    fields
    {
        field(1; "Proposal No."; Code[50])
        {
            TableRelation = Jobs."No.";
        }
        field(2; "Proposal Area Code"; Code[20])
        {
            TableRelation = "Proposal/Projects Areas setup".Code;

            trigger OnValidate()
            begin
                "Proposal/Projects Areas setup".Reset;
                "Proposal/Projects Areas setup".SetRange("Proposal/Projects Areas setup".Code, "Proposal Area Code");
                if "Proposal/Projects Areas setup".Find('-') then begin
                    "Proposal Area Description" := "Proposal/Projects Areas setup"."Area Description";
                end;
            end;
        }
        field(3; "Proposal Area Description"; Text[100]) { }
        field(4; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(5; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center BR";
        }
    }

    keys
    {
        key(Key1; "Proposal No.", "Proposal Area Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        "Proposal/Projects Areas setup": Record "Proposal/Projects Areas setup";
}

