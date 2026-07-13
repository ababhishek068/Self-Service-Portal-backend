table 50671 "Risk Register"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Project Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Category"; code[20])
        {
            TableRelation = "Risk Category";
            DataClassification = ToBeClassified;
        }
        field(4; "Opportunity/Threat"; Option)
        {
            OptionMembers = " ","Opportunity","Threat","Opp./Threat";
            DataClassification = ToBeClassified;
        }
        field(5; "Summary Description"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Detailed Description"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Rank Probability"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Most Likely (Cost)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Most Likely (Schedule)"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Response Category"; Option)
        {
            OptionMembers = " ","Accept","Share";
            DataClassification = ToBeClassified;
        }
        field(12; "Threat Response"; Option)
        {
            OptionMembers = " ","Mitigate","Transfer","Avoid";
            DataClassification = ToBeClassified;
        }
        field(13; "Oppurtunity Response"; Option)
        {
            OptionMembers = " ","Enhance","Exploit";
            DataClassification = ToBeClassified;
        }
        field(14; "Response"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Risk Owner"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Contingency Plan"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(17; Status; Option)
        {
            OptionMembers = " ","Active (Not Started)","Active (Ongoing)","Active (Complete)","Dormant (Not Started)","Retired (Complete)";
            DataClassification = ToBeClassified;
        }
        field(18; "Tracking Comments"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Cost Probability"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Consequence"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Severity (Priority)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Last Date Modified"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Campus Code"; code[20])
        {
            TableRelation = "Dimension Value".code where("Global Dimension No." = const(1));
            DataClassification = ToBeClassified;
        }
        field(24; "Department Code"; code[20])
        {
            TableRelation = "Dimension Value".code where("Global Dimension No." = const(2));
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}