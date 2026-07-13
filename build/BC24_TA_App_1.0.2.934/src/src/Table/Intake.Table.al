Table 50055 Intake
{
    LookupPageID = "Intake List";
    DrillDownPageId = "Intake List";

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[80]) { }
        field(3; Current; Boolean) { }
        field(4; "Reporting Date"; Date) { }
        field(5; "Reporting End Date"; Date) { }
        field(6; "Fees 2nd Instalment Deadline"; Date) { }
        field(7; Programme; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;
        }
        field(8; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Current Semester"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Semesters.code where("Current Semester" = filter(true));
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

    trigger OnDelete()
    begin
        CReg.Reset;
        CReg.SetRange(CReg.Semester, Code);
        if CReg.Find('-') then Error('Please note that you can not edit used Intake');
    end;

    trigger OnRename()
    begin
        if xRec.Code <> Code then begin
            CReg.Reset;
            CReg.SetRange(CReg.Semester, xRec.Code);
            if CReg.Find('-') then Error('Please note that you can not edit used Intake');
        end;
    end;

    var
        CReg: Record "Course Registration";
}

