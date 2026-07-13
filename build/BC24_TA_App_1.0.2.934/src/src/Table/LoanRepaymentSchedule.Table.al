table 50001 "Loan Repayment Schedule"
{
    Caption = 'Loan Repayment Schedule';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Loan No"; Code[20])
        {
            Caption = 'Loan No';
            TableRelation = "PR Transaction Codes"."Transaction Code";
            DataClassification = ToBeClassified;
        }
        field(2; "Employee No"; Code[20])
        {
            Caption = 'Employee No';
            TableRelation = "HR-Employee"."No.";
            DataClassification = ToBeClassified;
        }
        field(3; "Repayment Date"; Date)
        {
            Caption = 'Repayment Date';
            DataClassification = ToBeClassified;
        }
        field(4; "Loan Amount"; Decimal)
        {
            Caption = 'Loan Amount';
            DataClassification = ToBeClassified;
        }
        field(5; "Interest Rate"; Decimal)
        {
            Caption = 'Interest Rate';
            DataClassification = ToBeClassified;
        }
        field(6; "Loan Category"; Code[20])
        {
            Caption = 'Loan Category';
            DataClassification = ToBeClassified;
        }
        field(7; "Monthly Repayment"; Decimal)
        {
            Caption = 'Monthly Repayment';
            DataClassification = ToBeClassified;
        }
        field(8; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = ToBeClassified;
        }
        field(9; "Monthly Interest"; Decimal)
        {
            Caption = 'Monthly Interest';
            DataClassification = ToBeClassified;
        }
        field(10; "Principal Repayment"; Decimal)
        {
            Caption = 'Principal Repayment';
            DataClassification = ToBeClassified;
        }
        field(11; "Instalment No"; Integer)
        {
            Caption = 'Instalment No';
            DataClassification = ToBeClassified;
        }
        field(12; "Remaining Debt"; Decimal)
        {
            Caption = 'Remaining Debt';
            DataClassification = ToBeClassified;
        }
        field(13; "Payroll Group"; Code[20])
        {
            Caption = 'Payroll Group';

            DataClassification = ToBeClassified;
        }
        field(14; Paid; Boolean)
        {
            Caption = 'Paid';
            DataClassification = ToBeClassified;
        }

        field(16; "Transaction Name"; Text[150]) { }

        field(17; "Line No."; Integer)
        {
            AutoIncrement = true;
        }

        field(18; "Loan Balance"; Decimal) { }
    }
    keys
    {
        key(PK; "Loan No", "Employee No", "Repayment Date")
        {
            Clustered = true;
        }
    }
}
