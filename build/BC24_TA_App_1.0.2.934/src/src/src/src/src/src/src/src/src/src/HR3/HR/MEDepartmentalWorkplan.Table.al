table 50230 "ME Departmental Workplan"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PC Strategies";
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = TobeClassified;
        }
        field(2; Description; Code[20])
        {
            DataClassification = TobeClassified;
        }
        field(3; "Strategic Plan"; Code[20])
        {
            DataClassification = TobeClassified;
            TableRelation = "PC Strategies".Code;
        }
        field(4; "Strategic Plan Description"; text[2000])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PC Strategies".Description where(Code = field("Strategic Plan")));
        }
        field(5; "Strategic Objective"; Code[20])
        {
            DataClassification = TobeClassified;
            TableRelation = "PC Strategic Objectives".Code where("Strategic Plan" = field("Strategic Plan"));
        }
        field(6; "Strategic Objective Desc"; Text[2000])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PC Strategic Objectives".Description where(Code = field("Strategic Objective")));
        }
        field(7; "Annual Plan"; Code[20])
        {
            DataClassification = TobeClassified;
            TableRelation = "PC Annual Plan".Code;
        }
        field(8; "Annual Plan Descripton"; Text[2000])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PC Annual Plan".Description where(Code = field("Annual Plan")));

        }
        field(9; "Global Dimension 1"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));
        }
        field(10; "Global Dimension 2"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(2));
        }
        field(11; "Global Dimension 3"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(3));
        }
        field(12; "Global Dimension 4"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(4));
        }
        field(13; "Global Dimension 5"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(5));
        }
        field(14; "Created On"; DateTime)
        {
            DataClassification = TobeClassified;
        }
        field(15; "Created By"; Code[50])
        {
            DataClassification = TobeClassified;
        }
        field(16; "Last Modified On"; DateTime)
        {
            DataClassification = TobeClassified;
        }
        field(17; "Last Modified By"; Code[50])
        {
            DataClassification = TobeClassified;
        }
        field(18; "Status"; Option)
        {
            DataClassification = TobeClassified;
            OptionMembers = ,Open,"Pending Approval",Approved,Rejected,Cancelled;
        }
        field(19; "Global Dimension 6"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(6));
        }
    }
    keys
    {
        key(Code; Code)
        {
            Clustered = true;
        }

    }
    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created On" := CreateDateTime(Today, Time);
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified On" := CreateDateTime(Today, Time);
    end;
}