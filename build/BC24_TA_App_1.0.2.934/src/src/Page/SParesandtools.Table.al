table 51009 "SPares and tools"
{
    Caption = 'SPares and tools';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'EntryNo';
            AutoIncrement=true;
        }
        field(2; "Plate No"; Code[50])
        {
            Caption = 'Plate No';
            Editable=false;
        }
        field(3; "Chassis No"; Code[50])
        {
            Caption = 'Chassis No';
            Editable=false;
        }
        field(4; "Spare Code"; Code[20])
        {
            Caption = 'Spare Code';
        }
        field(5; "Spare description"; Text[50])
        {
            Caption = 'Spare description';
        }
        field(6; Quanity; Integer)
        {
            Caption = 'Quanity';
        }
        field(7; "Serial No"; Code[50])
        {
            Caption = 'Serial No';
        }
        field(8; Condition; option)
        {
            Caption = 'Condition';
            OptionMembers=working,"not working";
        }
        field(9;"Issue No";Code[20]){}
    }
    keys
    {
        key(PK; EntryNo,"Issue No","Plate No","Chassis No")
        {
            Clustered = true;
        }
    }
}
