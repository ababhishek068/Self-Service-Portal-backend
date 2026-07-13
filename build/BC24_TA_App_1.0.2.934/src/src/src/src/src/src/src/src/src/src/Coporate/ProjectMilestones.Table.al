table 50464 "Project Milestones"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            BlankZero = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; Milestone; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Amount Paybale"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /*IF Contract.GET("Contract No.") THEN BEGIN
                  Contract.CALCFIELDS("Milestone Amount");
                  IF ((Contract."Milestone Amount" + "Amount Paybale") > Contract."Contract Value") THEN ERROR('Total Milestome amount should not exceed contract Value amount');
                END;*/

            end;
        }
        field(5; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Pending,Complete,Cancelled;

            trigger OnValidate()
            begin
                IF xRec.Status = Status::Complete THEN
                    ERROR('Status of Milestone cannot be changed back to Pending');
            end;
        }
        field(7; Deliverables; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                TESTFIELD(Duration);
                "End Date" := CALCDATE(Duration, "Start Date");
            end;
        }
        field(9; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Duration; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Paid Milestone"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Unpaid Milestone"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "G/L Account".No. WHERE (Direct Posting=CONST(Yes),
            //                                         Account Type=CONST(Posting),
            //                                         Blocked=CONST(No));
        }
    }

    keys
    {
        key(Key1; "Line No.", "Project Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

