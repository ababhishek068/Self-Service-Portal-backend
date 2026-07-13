Table 50526 "HR Bank Summary"
{

    fields
    {
        field(1; "Line No."; Integer) { }
        field(2; "Bank Code"; Code[10])
        {
            TableRelation = "PR Bank Accounts"."Bank Code";
        }


        field(3; "Branch Code"; Code[10])
        {
            TableRelation = "PR Bank Branches"."Branch Code";
        }
        field(4; "Payroll Period"; Date)
        {
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(5; Amount; Decimal) { }
        field(6; "Transaction Code"; Code[10]) { }
        field(7; "No.";
        Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(8; "% NPAY"; Decimal) { }
        field(9; "Bank Name"; Text[100]) { }
        field(10; "Branch Name"; Text[100]) { }
        field(11; "Bank Type"; Option)
        {
            CalcFormula = lookup("PR Bank Accounts"."Bank Type" where("Bank Code" = field("Bank Code")));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = Bank,Sacco;
        }
        field(12; "Staff Bank Name"; Text[100]) { }
        field(13; "A/C Number"; Text[100]) { }
        field(50000; Status; Option)
        {
            CalcFormula = lookup("HR-Employee".Status where("No." = field("No.")));
            FieldClass = FlowField;
            OptionMembers = New,"Pending Approval",Active,InActive;

            trigger OnValidate()
            begin
            end;
        }
        field(50001; "Posting Group"; Code[20])
        {
            TableRelation = "PR Employee Posting Groups";
        }
        field(50002; "Employee Type"; Option)
        {
            OptionMembers = Normal,Secondary,Intern,Attachee;
        }

        field(50003; "Bank and Branch Code"; Code[20]) { }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

