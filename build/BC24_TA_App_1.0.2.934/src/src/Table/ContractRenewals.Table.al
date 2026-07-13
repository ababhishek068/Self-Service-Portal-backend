table 50673 "Contract Renewals"
{

    fields
    {
        field(1; "Contract Reference No"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                ;
            end;
        }
        field(2; "Contract Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Fixed Rate Contract Service,Fixed Rate Temporary Labour,Rate Base Temporary Labour';
            OptionMembers = " ","Fixed Rate Contract Service","Fixed Rate Temporary Labour","Rate Base Temporary Labour";
        }
        field(3; "Contractor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                IF vend.GET("Contractor No.") THEN
                    "Contractor Name" := UPPERCASE(vend.Name);
            end;
        }
        field(4; "Contractor Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Effective Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CLEAR("Expiry Date");


                "Expiry Date" := CALCDATE(Duration, "Effective Date");
            end;
        }
        field(6; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Contract Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(9; Duration; DateFormula)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Effective Date");
                CLEAR("Expiry Date");


                "Expiry Date" := CALCDATE(Duration, "Effective Date");
            end;
        }
        field(10; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Raised By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Posted By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Raised On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Posted On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Cancelled,Approved';
            OptionMembers = Open,"Pending Approval",Cancelled,Approved;
        }
        field(16; "Effective Date(Original)"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CLEAR("Expiry Date");


                "Expiry Date" := CALCDATE(Duration, "Effective Date");
            end;
        }
        field(17; "Expiry Date(Original)"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Contract Value(Original)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Contract Reference No", "Line No", "Contract Type", "Contractor No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        vend: Record Vendor;
}

