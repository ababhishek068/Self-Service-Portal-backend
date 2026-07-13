Table 50877 "Vote Transfer"
{
    LookupPageID = "Vote Transfer List";

    fields
    {
        field(1; No; Code[20]) { }
        field(2; Date; Date) { }
        field(3; "Source Vote"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(4; "Destination Vote"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(5; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(6; Amount; Decimal) { }
        field(7; "Source Dimmension 1"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(8; "Destination Dimmension 1"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(10; "Source Dimmension 2"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(11; "Destination Dimmension 2"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(12; Remarks; Text[200]) { }
        field(13; "Raised By"; Code[20]) { }
        field(14; "Raised Date"; Date) { }
        field(15; "Approved By"; Code[20]) { }
        field(16; "Approved Date"; Date) { }
        field(17; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(18; Posted; Boolean) { }
        field(19; "Posted Date"; Date) { }
        field(20; "Posted By"; Code[20]) { }
        field(21; "Source Department"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));
        }
        field(22; "Destination Department"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));
        }
        field(23; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Posted;
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if No = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Vote Transfer");
             No:=NoSeriesMgt.GetNextNo(GenLedgerSetup."Vote Transfer",  0D,true);

        end;
    end;

    var
        GenLedgerSetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit "No. Series";
}

