Table 50533 "HR Leave Allocation"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Calendar Code"; Code[50])
        {
            TableRelation = "HR Leave Calendar".Code where(Current = filter(true));
        }
        field(3; "No."; Code[50])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(4; "Staff Name"; Text[70]) { }
        field(5; "Posting Date"; Date) { }
        field(6; "Entry Type"; Option)
        {
            OptionMembers = " ","Positive Adjustment","Negative Adjustment";

            trigger OnValidate()
            begin
                if "Entry Type" = "Entry Type"::" " then begin
                    "No. Of days" := 0;
                end;
            end;
        }
        field(7; "Posting Type"; Option)
        {
            OptionMembers = Normal,Reimbursement,"Carry Forward";
        }
        field(8; "No. Of days"; Decimal)
        {
            AutoFormatType = 1;
        }
        field(9; "Posting Description"; Text[50])
        {
            Caption = 'Leave Posting Description';
        }
        field(10; "Global Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(11; "Global Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(12; "Posted By"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            begin
            end;
        }
        field(13; "Leave Type"; Code[50])
        {
            TableRelation = "Leave Types".Code;
        }
        field(14; Posted; Boolean) { }
        field(15; "Application Start Date"; Date) { }
        field(16; "Application End Date"; Date) { }
        field(17; "Application Return Date"; Date) { }
        field(18; "Calendar Start Date"; Date) { }
        field(19; "Calendar End Date"; Date) { }
        field(20; "Document No."; Code[50]) { }
        field(21; "Posting Source"; Option)
        {
            OptionMembers = Document,Batch;
        }
        field(22; Closed; Boolean) { }
        field(23; "Posted to Leave Ledger"; Boolean) { }
    }

    keys
    {
        key(Key1; "Entry No.", "No.", "Leave Type", "Calendar Code")
        {
            Clustered = true;
        }
        key(Key2; "Entry Type", "Posting Type")
        {
            SumIndexFields = "No. Of days";
        }
    }

    fieldgroups { }
    trigger OnInsert()
    begin
        "Posted By" := UserId;
    end;
}

