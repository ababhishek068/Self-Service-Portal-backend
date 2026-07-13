Table 50829 "Recruitment Needs"
{
    // DrillDownPageId=recruitme
    //  LookupPageID = UnknownPage39005846;

    fields
    {
        field(1; "Need Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Job ID"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            begin
                Jobs.Reset;
                Jobs.SetRange(Jobs."Job ID", "Job ID");
                if Jobs.Find('-') then
                    Description := Jobs."Job Description";
            end;
        }
        field(3; Date; Date) { }
        field(4; Priority; Option)
        {
            OptionCaption = 'High,Medium,Low';
            OptionMembers = High,Medium,Low;
        }
        field(5; Positions; Integer) { }
        field(6; Approved; Boolean)
        {

            trigger OnValidate()
            begin
                "Date Approved" := Today;
            end;
        }
        field(7; "Date Approved"; Date) { }
        field(8; Description; Text[200]) { }
        field(9; Stage; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Recruitment Stages"."Recruitement Stage";

            trigger OnValidate()
            begin
                /*
                RShort.RESET;
                RShort.SETRANGE(RShort."Need Code","Need Code");
                RShort.SETRANGE(RShort."Stage Code",Stage);
                RShort.CALCSUMS(RShort."Desired Score");
                Score:=RShort."Desired Score";
                */

            end;
        }
        field(10; Score; Decimal)
        {
            FieldClass = Normal;
        }
        field(11; "Stage Code"; Code[20])
        {
            TableRelation = "Recruitment Stages"."Recruitement Stage";
        }
        field(12; Qualified; Boolean)
        {
            FieldClass = Normal;
        }
        field(13; "No Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }
        field(14; "Start Date"; Date) { }
        field(15; "End Date"; Date)
        {
            Editable = false;
        }
        field(16; "Documentation Link"; Text[200]) { }
        field(17; "Turn Around Time"; Integer)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Need Code", "Job ID")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Jobs: Record "Company Jobs";
}

