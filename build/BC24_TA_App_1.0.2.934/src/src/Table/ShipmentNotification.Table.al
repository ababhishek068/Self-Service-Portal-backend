table 50036 "Shipment Notification"
{

    fields
    {
        field(1; "Notification No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Purchase Order"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Vendor; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Time; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Location; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Invoice Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Delivery Note"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Notification No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

