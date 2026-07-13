Table 50303 "Programmes Cap. Declaration"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Academic Year"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Year".Code;
        }
        field(3; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Remarks; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval, Approved,Rejected,Cancelled';
            OptionMembers = Open,"Pending Approval"," Approved",Rejected,Cancelled;
        }
        field(6; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if Code = '' then begin
            GeneralSetup.Get;
            GeneralSetup.TestField(GeneralSetup."Programme Cap.Declaration Nos.");
            Code:=NoSeriesMgt.GetNextNo(GeneralSetup."Programme Cap.Declaration Nos.", 0D, true);
        end;
    end;

    var
        GeneralSetup: Record "General Set-Up";
        NoSeriesMgt: Codeunit "No. Series";
}

