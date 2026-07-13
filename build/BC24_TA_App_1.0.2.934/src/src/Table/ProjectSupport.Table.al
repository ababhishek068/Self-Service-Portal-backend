Table 50259 "Project Support"
{

    fields
    {
        field(1; "Project No"; Code[20]) { }
        field(2; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Reported Date"; Date) { }
        field(4; "Project Module"; Code[20])
        {
            TableRelation = "Project Modules".Code;
        }
        field(5; "Urgency Level"; Option)
        {
            OptionCaption = ' ,Low,Moderate,High';
            OptionMembers = " ",Low,Moderate,High;
        }
        field(6; "Issue Description"; Text[250]) { }
        field(7; Status; Option)
        {
            OptionCaption = ' ,Open,Pending Client Confirmation,Closed,On-going';
            OptionMembers = " ",Open,"Pending Client Confirmation",Closed,"On-going";
        }
        field(8; "Closing Date"; Date) { }
        field(9; "Closed By"; Code[20]) { }
        field(10; "Client Closing Remarks"; Text[200]) { }
        field(11; "Client Remarks"; Text[200]) { }
        field(12; "Assigned Staff No"; Code[20])
        {
            CalcFormula = lookup("Project Task Allocation"."Staff No" where("Support Entry No" = field("Entry No")));
            FieldClass = FlowField;
        }
        field(13; "Report Source"; Option)
        {
            OptionCaption = ' ,Email,Phone,Meeting,Verbal';
            OptionMembers = " ",Email,Phone,Meeting,Verbal;
        }
        field(14; "Project Type"; Option)
        {
            CalcFormula = lookup(Projects."Project Type" where(No = field("Project No")));
            FieldClass = FlowField;
            OptionCaption = ' ,Implementation,Support';
            OptionMembers = " ",Implementation,Support;
        }
        field(15; Client; Text[150])
        {
            CalcFormula = lookup(Projects."Customer Name" where(No = field("Project No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Project No", "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

