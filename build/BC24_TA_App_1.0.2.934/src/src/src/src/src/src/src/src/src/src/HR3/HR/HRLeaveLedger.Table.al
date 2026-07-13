Table 50846 "HR Leave Ledger"
{

    fields
    { 
        field(1; "Employee No"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(8; "Entry No."; Integer) { }
        field(9; "Document No"; Code[30]) { }
        field(10; "Leave Type"; Code[20])
        {
            TableRelation = "Leave Types".Code;
        }
        field(11; "Transaction Date"; Date) { }
        field(12; "Transaction Type"; Option)
        {
            OptionCaption = ' ,Allocation,Application,Positive Adjustment,Negative Adjustment,Reimbursed';
            OptionMembers = " ",Allocation,Application,"Positive Adjustment","Negative Adjustment",Reimbursed;
        }


        field(13; "No. of Days"; Decimal) { }
        field(14; "Transaction Description"; Text[250]) { }
        field(15; "Leave Period"; Integer) { }
        field(16; "Entry Type"; Option)
        {
            OptionCaption = 'Application,Allocation';
            OptionMembers = Application,Allocation;
        }
        field(17; "Created By"; Code[30])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(18; "Reversed By"; Code[30])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(19; "Closed"; Boolean) { }
        field(20; "Leave Posting Type"; Option)
        {
            OptionCaption = 'Normal,Carry Forward,Reimbursement';
            OptionMembers = Normal,"Carry Forward",Reimbursement;
        }

    }

    keys
    {
        key(Key1; "Entry No.", "Document No")
        {
            Clustered = true;
        }
        key(Key2; "Employee No", "Leave Type")
        {
            SumIndexFields = "No. of Days";
        }
        key(Key3; "Employee No", "Transaction Date")
        {
            SumIndexFields = "No. of Days";
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Created By" := UserId;
    end;
}

