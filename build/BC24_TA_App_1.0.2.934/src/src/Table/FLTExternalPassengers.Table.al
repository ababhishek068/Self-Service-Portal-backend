table 50010 "FLT-External Passengers"
{
    Caption = 'FLT-External Passengers';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            Caption = 'Line No';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Transport No."; Code[30])
        {
            Caption = 'Transport No.';
            DataClassification = ToBeClassified;
            TableRelation="FLT-Transport Requisition"."Transport Requisition No";
        }
        field(3; "Passenger Names"; Text[250])
        {
            Caption = 'Passenger Names';
            DataClassification = ToBeClassified;
        }
        field(4; "Passenger Organization"; Text[150])
        {
            Caption = 'Passenger Organization';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Line No","Transport No.")
        {
            Clustered = true;
        }
    }
}
