table 50179 "SASRA Annual Levy"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Levy Year"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Customer No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(3; "Name"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Total Deposit"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                CashOffice: Record "Cash Office Setup";
            begin
                CashOffice.get;
                "Levy Computation" := "Total Deposit" + CashOffice."Levy Rate";
                if "Levy Computation" > CashOffice."Max Levy Payable" then
                    "Levy Computation" := CashOffice."Max Levy Payable";
            end;

        }
        field(5; "Levy Computation"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Levy Capped"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Posted"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Invoice No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Posted By"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Posting Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Serial No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Selected"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Levy Year", "Customer No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin
        TestField(Posted, false);
    end;

    trigger OnDelete()
    begin
        TestField(Posted, false);
    end;

    trigger OnRename()
    begin

    end;

}