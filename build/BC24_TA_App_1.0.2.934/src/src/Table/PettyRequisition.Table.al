table 50920 "Petty Requisition"
{
    Caption = 'Petty Requisition';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(2; Req_No; Code[20])
        {
            Caption = 'Req_No';
            DataClassification = CustomerContent;
        }
        field(3; "Requisition Date"; Date)
        {
            Caption = 'Requisition Date';
            DataClassification = CustomerContent;
        }
        field(4; "Time Requested"; Time)
        {
            Caption = 'Time Requested';
            DataClassification = CustomerContent;
        }
        field(5; "Requested By"; Code[50])
        {
            Caption = 'Requested By';
            DataClassification = CustomerContent;
        }
        field(6; Payee; Text[50])
        {
            Caption = 'Payee';
            DataClassification = CustomerContent;
        }
        field(7; Purpose; Text[150])
        {
            Caption = 'Purpose';
            DataClassification = CustomerContent;
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(9; "No. Series"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Status; Option)
        {
            Description = 'approval';
            OptionMembers = open,Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
            OptionCaption = 'open,Pending,1st Approval,2nd Approval,Cheque Printing,Posted,Cancelled,Checking,VoteBook,Pending Approval,Approved';

            // trigger OnValidate()         

        }

        field(11; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Enabled = true;
            TableRelation = Currency;
        }

    }
    keys
    {
        key(PK; "Entry No", Req_No, Amount)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if Req_No = '' then begin
            GenLedgerSetup.Get;

            GenLedgerSetup.TestField(GenLedgerSetup."Petty Cash Nos");
            Req_No:=NoSeriesMgt.GetNextNo(GenLedgerSetup."Petty Cash Nos", 0D, true);
            "Requested By" := UserId;
            "Time Requested" := Time;
            "Requisition Date" := Today;
        end;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Cash Office Setup";
}
