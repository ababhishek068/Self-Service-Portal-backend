Table 50699 "Payment Schedule"
{

    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                GenLedgerSetup.Get;
                GenLedgerSetup.TestField(GenLedgerSetup."Payment Schedule No");
                 No:=NoSeriesMgt.GetNextNo(GenLedgerSetup."Payment Schedule No", 0D,true);
            end;
        }
        field(2; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Paying Bank No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No." where("Bank Type" = const(Normal));

            trigger OnValidate()
            begin
                if BankRec.Get("Paying Bank No") then begin
                    BankRec.TestField("Last Check No.");
                    "Cheque No" := IncStr(BankRec."Last Check No.");
                    "Cheque Format" := BankRec."Cheque Format";
                end;
            end;
        }
        field(4; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Payment Schedule Line"."Cheque Amount" where(No = field(No)));
            FieldClass = FlowField;
        }
        field(5; Payee; Text[150])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Payee := UpperCase(Payee);
            end;
        }
        field(6; "Cheque No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Pending,Pending Approval,Approved';
            OptionMembers = Pending,"Pending Approval",Approved;
        }
        field(9; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Posted By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Posting Dated"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Cheque Format"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Kalamazoo Format,Plain Format';
            OptionMembers = "Kalamazoo Format","Plain Format";
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
        //IF No = '' THEN BEGIN
        GenLedgerSetup.Get;
        GenLedgerSetup.TestField(GenLedgerSetup."Payment Schedule No");
        No:=NoSeriesMgt.GetNextNo(GenLedgerSetup."Payment Schedule No",  0D, true);
        //END
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Cash Office Setup";
        BankRec: Record "Bank Account";
}

