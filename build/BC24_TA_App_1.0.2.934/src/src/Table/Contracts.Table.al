Table 50361 Contracts
{

    fields
    {
        field(1; "Contract No"; Code[20]) { }
        field(2; Client; Code[10])
        {
            TableRelation = Customer."No." where("No." = field(Client));

            trigger OnValidate()
            begin
                NextNo := NoSeriesMgt.GetNextNo('CONTRACT', Today, true);
                "Contract No" := NextNo;
            end;
        }
        field(3; "Contract Type"; Code[30])
        {
            TableRelation = "CRM Contract Types".Code where(Code = field("Contract Type"));
        }
        field(4; "Date Signed"; Date) { }
        field(5; "Expiry Date"; Date) { }
        field(6; Description; Text[100]) { }
        field(7; "Start Date"; Date) { }
        field(8; "Contract Amount"; Decimal) { }
    }

    keys
    {
        key(Key1; "Contract No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        NextNo := NoSeriesMgt.GetNextNo('CONTRACT', Today, true);
        "Contract No" := NextNo;
    end;

    var
        NextNo: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
}

