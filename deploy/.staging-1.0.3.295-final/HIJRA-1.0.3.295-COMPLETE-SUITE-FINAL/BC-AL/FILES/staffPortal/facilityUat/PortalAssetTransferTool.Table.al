/// <summary>
/// The subset of accessories/tools selected for one portal Asset Transfer.
/// Values are copied from Asset Accessories when the requester adds a line so
/// the approval remains an accurate audit snapshot if the master later changes.
/// </summary>
table 52174 "Portal Asset Transfer Tool"
{
    Caption = 'Portal Asset Transfer Tool';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Transfer No."; Code[20])
        {
            Caption = 'Transfer No.';
            TableRelation = "Asset Transfer"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Accessory Entry No."; Integer)
        {
            Caption = 'Accessory Entry No.';
        }
        field(4; "Vehicle No."; Code[20])
        {
            Caption = 'Vehicle No.';
        }
        field(5; "Vehicle Registration No."; Code[50])
        {
            Caption = 'Vehicle Registration No.';
        }
        field(6; "Tool Code"; Code[20])
        {
            Caption = 'Tool Code';
        }
        field(7; "Tool Description"; Text[50])
        {
            Caption = 'Tool Description';
        }
        field(8; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(9; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
        }
        field(10; Condition; Text[30])
        {
            Caption = 'Condition';
        }
        field(11; Remarks; Text[200])
        {
            Caption = 'Remarks';
        }
    }

    keys
    {
        key(PK; "Transfer No.", "Line No.")
        {
            Clustered = true;
        }
        key(Accessory; "Transfer No.", "Accessory Entry No.") { }
    }
}
