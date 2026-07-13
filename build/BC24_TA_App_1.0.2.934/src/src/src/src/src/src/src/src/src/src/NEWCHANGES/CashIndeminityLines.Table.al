table 51014 "Cash Indeminity Lines"
{
    Caption = 'Cash Indeminity Lines';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'EntryNo';
        }
        field(2; "Staff No"; Code[20])
        {
            Caption = 'Staff No';
        }
        field(3; "Staff Name"; Text[50])
        {
            Caption = 'Staff Name';
        }
        field(4; "Works in?"; Option)
        {
            Caption = 'Works in?';
            OptionMembers=Division,Branch;
        }
        field(5; "Job Group"; Code[20])
        {
            Caption = 'Job Group';
        }
        field(6; "Salary Grade"; Code[20])
        {
            Caption = 'Salary Grade';
        }
        field(7; "No of Days Worked"; Integer)
        {
            Caption = 'No of Days Worked';
        }
        field(8; "Calculated Cash Indeminity"; Decimal)
        {
            Caption = 'Calculated Cash Indeminity';
        }
        field(9; "Accumulated Cash Indemnity"; Decimal)
        {
            Caption = 'Accumulated Cash Indemnity';
        }
        field(10;"Cash Indeminity Code";code[20])
        {

        }
        field(11;"Payroll Period";Date){}
        field(12;"Period Month";Integer){}
        field(13;"Period Year";integer){}
    }
    keys
    {
        key(PK; EntryNo,"Cash Indeminity Code","Payroll Period")
        {
            Clustered = true;
        }
    }
}
