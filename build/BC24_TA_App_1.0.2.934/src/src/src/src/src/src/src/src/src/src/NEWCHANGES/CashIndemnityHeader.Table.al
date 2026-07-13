table 51013 "Cash Indemnity Header"
{
    Caption = 'Cash Indemnity Header';
    DataClassification = ToBeClassified;
    DrillDownPageId="Cash Indemnity List";
    
    fields
    {
        field(1; "Cash Idemnity Code"; Code[20])
        {
            Caption = 'Cash Idemnity Code';
        }
        field(2; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
        }
        field(3; "Payroll Month"; Integer)
        {
            Caption = 'Payroll Month';
        }
        field(4; "Payroll Year"; Integer)
        {
            Caption = 'Payroll Year';
        }
        field(5; "Total Cash Indemnity"; Decimal)
        {
            Caption = 'Total Cash Indemnity';
        }
        field(6; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(7; "Date Created"; Date)
        {
            Caption = 'Date Created';
        }
        field(8; Status; Option)
        {
            Caption = 'Status';
            OptionMembers=Open,Approved,Rejected;
        }
        field(9;"No of Working Days";Integer){
            Editable=false;
            }
    }
    keys
    {
        key(PK; "Cash Idemnity Code","Payroll Period")
        {
            Clustered = true;
        }
    }
}
