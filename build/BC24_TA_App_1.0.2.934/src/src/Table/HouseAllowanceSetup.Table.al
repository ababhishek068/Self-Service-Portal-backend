table 51022 "House Allowance Setup"
{
    Caption = 'House Allowance Setup';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
        }
        field(2; "Lower Salary Grade Limit"; Integer)
        {
            Caption = 'Lower Salary Grade Limit';
        }
        field(3; "Upper Salary Grade Limit"; Integer)
        {
            Caption = 'Upper Salary Grade Limit';
        }
        field(4; "Perrcentage of Basic"; Decimal)
        {
            Caption = 'Perrcentage of Basic';
        }
        field(5; Active; Boolean)
        {
            Caption = 'Active';
        }
    }
    keys
    {
        key(PK; "Lower Salary Grade Limit","Upper Salary Grade Limit",Active)
        {
            Clustered = true;
        }
    }
}
