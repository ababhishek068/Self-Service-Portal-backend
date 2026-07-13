Table 50354 "Int. Audits"
{

    fields
    {
        field(1; "Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Work Plan"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Int. Audit Work Plans".Code;
        }
        field(3; "Audit Area"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Int. Audit Areas".Code;
            trigger OnValidate()
            var
                TbAuditAreas: Record "Int. Audit Areas";
            begin
                if TbAuditAreas.Get("Audit Area") then begin
                    Objectives := TbAuditAreas.Objectives;
                    Indicators := TbAuditAreas.Indicators;
                    // if SectionCode.get(TbAuditAreas."Section Code") then
                    //  "Risk Level":=SectionCode.Ranking;
                end;
            end;
        }
        field(4; "Risk Level"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',High,Medium,Low';
            OptionMembers = ,High,Medium,Low;
        }
        field(5; Objectives; Text[2000])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; Indicators; Text[2000])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Date Created"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Created By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Date Edited"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Last Editor"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(17; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,On Going,Done,Not Done';
            OptionMembers = New,"On Going",Done,"Not Done";
        }
        field(18; Comments; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Work Plan Name"; Text[250])
        {
            CalcFormula = lookup("Int. Audit Work Plans".Description where(Code = field("Work Plan")));
            FieldClass = FlowField;
        }
        field(20; "Audit Area Name"; Text[250])
        {
            CalcFormula = lookup("Int. Audit Areas"."Area of Audit" where(Code = field("Audit Area")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code", "Work Plan", "Audit Area")
        {
            Clustered = true;
        }
        key(MyKey; "Work Plan", "Audit Area")
        {
            Unique = true;
        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Audit Area Name", "Work Plan Name") { }
    }
}

