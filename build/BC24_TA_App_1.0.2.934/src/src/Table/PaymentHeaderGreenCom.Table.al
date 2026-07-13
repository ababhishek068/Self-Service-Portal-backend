table 50011 "Payment Header GreenCom"
{
    Caption = 'Payment Header GreenCom';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "PV No"; Code[20])
        {
            Caption = 'PV No';
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = " ","Direct Voucher","Petty Cash";
        }
        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if Vend.get("Vendor No.") then
                    "Vendor Name" := Vend.Name;
            end;
        }
        field(4; "Vendor Name"; Text[200])
        {
            Caption = 'Vendor Name';
        }
        field(5; "Posting Description"; Text[250])
        {
            Caption = 'Posting Description';
        }
        field(6; "Paying Bank"; Code[20])
        {
            Caption = 'Paying Bank';
            TableRelation = "Bank Account"."No.";
        }
        field(7; "Paying Bank Name"; Text[100])
        {
            Caption = 'Paying Bank Name';
        }
        field(8; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(9; "Raised By"; Code[50])
        {
            Caption = 'Raised By';
            TableRelation = "User Setup"."User ID";
        }
        field(10; "Modified Date"; DateTime)
        {
            Caption = 'Modified Date';
        }
        field(11; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(12; "Payment Mode"; Option)
        {
            Caption = 'Payment Mode';
            OptionMembers = Bank,Cash,Cheque,"M-Pesa";
        }
        field(13; "Cheque No"; Code[50])
        {
            Caption = 'Cheque No';
        }
        field(14; "No. Series"; Code[20])
        {
            Description = 'Stores the number series in the database';
        }
        field(15; "Total amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Direct Voucher Lines"."Invoice Amount" where("Document No" = field("PV No")));
        }
        field(16; Posted; Boolean) { }
        field(17; "Posted By"; Code[50])
        {
            Caption = 'Raised By';
            TableRelation = "User Setup"."User ID";
        }
    }

    keys
    {
        key(PK; "PV No", "Document Type")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "PV No" = '' then begin
            GenLedgerSetup.Get;

            GenLedgerSetup.TestField(GenLedgerSetup."GreenCom PV Nos");
            "PV No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."GreenCom PV Nos", 0D, true);
            "Document Date" := Today;
            "Raised By" := UserId;

        end;
    end;


    var
        GenLedgerSetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit "No. Series";
}
