Table 50118 Lessons
{
    DrillDownPageID = Lessons;
    LookupPageID = Lessons;

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(3; Descrition; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Start Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "End Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "No Of Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Full Time/Part Time"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Full Time,Part Time';
            OptionMembers = "Full Time","Part Time";
        }
        field(8; "Main Session"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Student Types".Code;
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;
        }
        field(9; "Sub Session"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Student Types".Code;
        }
        field(10; "Session Filter"; Code[50])
        {
            FieldClass = FlowFilter;
            TableRelation = "Student Types".Code;
        }
        field(11; "Applicable Day"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Day Of Week".Day;
        }
        field(12; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Teaching,Exam';
            OptionMembers = Teaching,Exam;
        }
        field(13; "Used Count"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Active; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.", "Code")
        {
            Clustered = true;
        }
        key(Key2; "Used Count") { }
    }

    fieldgroups { }
}

