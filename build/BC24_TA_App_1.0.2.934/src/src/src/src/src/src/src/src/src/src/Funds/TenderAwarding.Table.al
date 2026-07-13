Table 50506 "Tender Awarding"
{

    fields
    {
        field(1; "Tender No"; Code[50])
        {
            TableRelation = Tender where(Open = filter(true));
        }
        field(2; "Item No"; Code[50])
        {
            TableRelation = Item;
        }
        field(3; "Quantity Awarded"; Decimal) { }
        field(4; "Awarded Bidder"; Code[50])
        {
            NotBlank = true;
            TableRelation = Bidder;
        }
        field(5; "Awarded No"; Integer)
        {

            trigger OnValidate()
            begin
                TenderAward.Reset;

                TenderAward.SetRange(TenderAward."Tender No", "Tender No");
                TenderAward.SetRange(TenderAward."Item No", "Item No");
                //tenderAward.SETRANGE(tenderAward."Awarded Bidder","Awarded Bidder");
                TenderAward.SetRange(TenderAward."Awarded No", "Awarded No");

                if (TenderAward.Find('-')) then Error('You cannot Award same Rank twice');
            end;
        }
        field(6; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Tender No", "Item No", "Awarded Bidder")
        {
            Clustered = true;
        }
        key(Key2; "Awarded No") { }
    }

    fieldgroups { }

    var
        TenderAward: Record "Tender Awarding";
        }

