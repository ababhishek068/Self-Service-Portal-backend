table 50234 "EOI Bids"
{
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
        }
        field(3; "Vendor Name"; text[300])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
        }
        field(4; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Quote Header"."No.";
        }
        field(5; "Submitted On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Submitted",Success,Dropped;
        }
        field(7; "Actioned By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Actioned On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "No.", "Document No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        Noseriesmgt: Codeunit "No. Series";
    begin
        IF "No." = '' then begin
            PurchSetup.Get();
            PurchSetup.TestField("EOI Nos");
            "No." := Noseriesmgt.GetNextNo(PurchSetup."EOI Nos", 0D, true);
            Status := Status::Submitted;
            "Submitted On" := CreateDateTime(Today, time);
        end;

    end;
}