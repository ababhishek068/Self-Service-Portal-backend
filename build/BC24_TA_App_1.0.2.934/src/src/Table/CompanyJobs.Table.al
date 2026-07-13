Table 50780 "Company Jobs"
{


    fields
    {
        field(1; "Job ID"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Job Description"; Text[250]) { }
        field(3; "No of Posts"; Integer)
        {

            trigger OnValidate()
            begin
                if "No of Posts" <> xRec."No of Posts" then
                    "Vacant Posistions" := "No of Posts" - "Occupied Position";
            end;
        }
        field(4; "Position Reporting to"; Code[20])
        {
            TableRelation = "Company Jobs"."Job ID";
        }
        field(5; "Occupied Position"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Position = field("Job ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Vacant Posistions"; Integer) { }
        field(7; "Score code"; Code[20])
        {
            TableRelation = "Score Setup";
        }
        field(8; "Dimension 1"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(9; "Dimension 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(10; "Dimension 3"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(11; "Dimension 4"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(12; "Dimension 5"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
        }
        field(13; "Dimension 6"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
        }
        field(14; "Dimension 7"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
        }
        field(15; "Dimension 8"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
        }
        field(16; "No of Position"; Integer) { }
        field(17; "Total Score"; Decimal)
        {
            CalcFormula = sum("Job Requirement"."Score ID" where("Job Id" = field("Job ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Stage filter"; Integer)
        {
            FieldClass = FlowFilter;
            TableRelation = "Recruitment Stages";
        }
        field(19; Objective; Text[250]) { }
        field(21; "Key Position"; Boolean) { }
        field(22; Category; Code[20]) { }
        field(23; Grade; Code[20]) { }
        field(24; "Primary Skills Category"; Option)
        {
            OptionMembers = Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(25; "2nd Skills Category"; Option)
        {
            OptionMembers = Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(26; "3nd Skills Category"; Option)
        {
            OptionMembers = Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(27; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));
        }
    }

    keys
    {
        key(Key1; "Job ID")
        {
            Clustered = true;
        }
        key(Key2; "Vacant Posistions") { }
        key(Key3; "Dimension 1") { }
        key(Key4; "Dimension 2") { }
    }

    fieldgroups { }
}

