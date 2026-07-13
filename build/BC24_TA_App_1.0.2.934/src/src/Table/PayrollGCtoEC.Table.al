table 51019 "Payroll GC to EC"
{
    Caption = 'Payroll GC to EC';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; Month; Integer)
        {
            Caption = 'GC Month';
        }
        field(2; "Select Date"; Date)
        {
            Caption = 'Select Date';
            trigger OnValidate()
            begin
                month:=Date2DMY(rec."Select Date",2);
            end;
        }
        field(3; "GC Name"; Text[100])
        {
            Caption = 'GC Name';
        }
        field(4; "EC Name"; Text[100])
        {
            Caption = 'EC Name';
        }
        field(5;"EC Month";Integer){}
        field(6;"GC Payroll Period Open Date";Date){
            
        }
    }
    keys
    {
        key(PK; Month)
        {
            Clustered = true;
        }
    }
}
