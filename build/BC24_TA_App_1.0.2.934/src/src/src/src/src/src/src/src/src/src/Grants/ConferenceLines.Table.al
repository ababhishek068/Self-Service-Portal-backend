Table 50467 "Conference Lines"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "No."; Code[25])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Conference Attendance"."Req No.";
        }
        field(3; "Expense Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Food,Accomodation,Registaration Fee,Other Fee,Own Contribution,Travel';
            OptionMembers = ,Food,Accomodation,"Registaration Fee","Other Fee","Own Contribution",Travel;
        }
        field(4; Quantity; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Unit of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure".Code;
        }
        field(6; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Total := "Unit Cost" * Quantity;
            end;
        }
        field(7; Total; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Author's Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Presenter No."; Integer)
        {
            AutoIncrement = false;
            DataClassification = ToBeClassified;
        }
        field(10; "No. Series"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Line No.", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        /*IF "No." = '' THEN BEGIN
         GenLedgerSetup.GET();
         GenLedgerSetup.TESTFIELD(GenLedgerSetup."Stores Requisition No");
         NoSeriesMgt.GetNextNo(GenLedgerSetup."Stores Requisition No",xRec."No. Series",0D,"No.","No. Series");
       END;
       */

    end;
}

