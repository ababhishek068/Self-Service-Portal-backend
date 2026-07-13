#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50955 Signatories
{

    fields
    {
        field(1;Department;Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=filter(3));
        }
        field(2;"1st Signatory";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"2nd Signatory";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"3rd Signatory";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5;Stamp;Blob)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(6;Signature1;Blob)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(7;Signature2;Blob)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(8;Signature3;Blob)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(9;Title1;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Title 2";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Title 3";Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;Department)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

