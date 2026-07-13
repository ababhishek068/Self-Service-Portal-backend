table 50534 "PR Payroll Buffer"
{
    Caption = 'PRPayroll Buffer';
    DataClassification = ToBeClassified;

    fields
    {

        field(1; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Payroll-Num"; Code[20])
        {
            Caption = 'Payroll-Num';
            DataClassification = ToBeClassified;
        }

        field(5; "BRS Staff No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(7; "ED-Code"; Code[20]) { }

        field(9; "Transaction Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(11; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
        }

        field(13; "Balance"; Decimal)
        {
            BlankZero = true;
        }

        field(15; "Ref-Account"; Code[50])
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }

}
