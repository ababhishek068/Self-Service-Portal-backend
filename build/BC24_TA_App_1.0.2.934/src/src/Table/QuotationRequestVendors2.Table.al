Table 50729 "Quotation Request Vendors2"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = " ",RFQ;
        }
        field(2; "RFQ No."; Code[20])
        {
            Editable = false;
            TableRelation = "Purchase Quote Header"."No.";
        }
        field(3; "Vendor No."; Code[20])
        {
            TableRelation = Vendor where("Vendor Posting Group" = filter(<> 'DRIVERS'));
        }
        field(4; "Vendor Name"; Text[50])
        {
            Editable = false;
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(6; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(7; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(8; "Request Summary"; Text[50])
        {
            Description = 'Purchase Requisition Request Summary';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "RFQ No.", "Vendor No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "RFQ No.", "Vendor No.", "Shortcut Dimension 1 Code", Status) { }
    }
}

