table 50982 "Asset Accessories"
{
    Caption = 'Asset Accessories';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Asset No"; Code[50])
        {
            Caption = 'Asset No';
        }
        field(2; "Tag No"; Code[50])
        {
            Caption = 'Tag No';
        }
        field(3; "Accessory Code"; Code[20])
        {
            Caption = 'Accessory Code';
        }
        field(4; "Accessory Name"; Text[50])
        {
            Caption = 'Accessory Name';
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
            
        }
        field(6; Condition; Option)
        {
            Caption = 'Condition';
            OptionMembers=Working,"Not Working";
        }
        field(7; EntryNo; integer)
        {
            Caption = 'EntryNo';
            AutoIncrement=true;
        }
        field(8;"Serial No";Code[50]){
            trigger OnValidate()
            begin
                if "Serial No"<>'' then begin
                    "Has SN?":=true;
                end else begin
                    "Has SN?":=false;
                end;
                Validate("Has SN?");
            end;
        }
        field(9;"Has SN?";Boolean){
            trigger OnValidate()
            begin
                if "Has SN?"=true then begin
                    if Quantity<>1 then
                    Error('Cannot have more than qty for items with SN, you must list the items');
                end;
            end;
            
        }
        field(12;"Return Code";Code[20]){}
    }
    keys
    {
        key(PK; "Asset No","Accessory Code","Serial No","Tag No","Return Code")
        {
            Clustered = true;
        }
    }
}
