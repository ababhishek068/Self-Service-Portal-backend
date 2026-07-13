Table 50908 "CshMgt Application"
{


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = PV,Receipt;
        }
        field(2; "Document No."; Code[20]) { }
        field(3; "Line No."; Integer) { }
        field(4; Amount; Decimal) { }
        field(5; "Amount Applied"; Decimal) { }
        field(6; "Appl. Doc. Type"; Text[30]) { }
        field(7; "Appl. Doc. No"; Code[20]) { }
        field(8; "Appl. Ext Doc. Ref"; Code[20]) { }
        field(9; "Appl. Description"; Text[100]) { }
        field(10; "Line Number"; Integer)
        {
            AutoIncrement = true;
        }
        field(11; "Appl. Doc. Original Amount"; Decimal) { }
        field(12; "Appl. Doc. Amount"; Decimal) { }
        field(13; "Appl.Doc. Amount Including VAT"; Decimal) { }
        field(14; "Appl. Doc. VAT Amount"; Decimal) { }
        field(15; "Appl. Doc. VAT Rate"; Decimal) { }
        field(16; "Appl. Doc. Remaining Amount"; Decimal) { }
        field(17; "Appl. Doc. VAT Paid"; Decimal)
        {
            Description = 'this is theoretical';
        }
        field(18; "Appl. Doc. VAT To Pay"; Decimal)
        {
            Description = 'this is far-fetched but can work';
        }
        field(19; "Appl. Doc Date"; Date) { }
        field(20; "VAT Base Amount"; Decimal) { }
        field(21; "Customer No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(22; No; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No, "Document No.")
        {
            Clustered = true;
        }
        key(Key2; "Appl. Doc. No", "Document Type", "Appl. Doc. Type")
        {
            SumIndexFields = "Amount Applied";
        }
    }

    fieldgroups { }
}

