Table 50291 "Online Results Release"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Semester; Code[20])
        {
            TableRelation = Semesters.Code;
        }
        field(3; Date; Date) { }
        field(4; UserID; Code[20]) { }
        field(5; Posted; Boolean) { }
        field(6; "Release Type"; Option)
        {
            OptionCaption = ' ,Normal,School Based,Exemption';
            OptionMembers = " ",Normal,"School Based",Exemption;
        }
        field(7; "Academic Year"; Code[20])
        {
            TableRelation = "Academic Year".Code;
        }
        field(8; "Campus Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(9; "Programme Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;
        }
        field(10; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Units/Subjects".Code;
        }
        field(11; "Mode of Study"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Student Types".Code;
        }
        field(12; "Student No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(13; "Credit Transfers"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Programme Option"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Programme Options".Code where("Programme Code" = field("Programme Code"));
        }
        field(15; Stage; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Code"));
        }
        field(16; "No. Series"; Code[20]) { }
        field(17; "Include Units Without Marks"; Boolean) { }

    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        AppSetup: Record "General Set-Up";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        AppSetup.Get;
        if Code = '' then begin
            AppSetup.Get;
            AppSetup.TestField("Marks Approval Nos");
             Code:=NoSeriesMgt.GetNextNo(AppSetup."Marks Approval Nos",  0D,true);
        end;
    end;

}

