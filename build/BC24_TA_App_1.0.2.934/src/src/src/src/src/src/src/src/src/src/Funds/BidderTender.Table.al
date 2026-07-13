Table 50497 "Bidder Tender"
{

    fields
    {
        field(1; "Tender ID"; Code[20])
        {
            NotBlank = true;
            TableRelation = Tender."Tender ID";
        }
        field(2; "TIN No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Bidder."PIN No";
        }
        field(3; "Date Created"; Date)
        {
            Editable = false;
            NotBlank = true;
        }
        field(4; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(5; "Receipt No."; Code[20])
        {
            Editable = true;
            NotBlank = true;
        }
        field(8; "Non Refundable Fee"; Decimal)
        {
            Editable = false;
            MinValue = 5000;
        }
        field(9; Status; Option)
        {
            OptionCaption = 'Open,Undergoing Approval,Approved,Rejected,Cancelled';
            OptionMembers = Open,"Undergoing Approval",Approved,Rejected,Cancelled;
        }
        field(10; Comment; Text[250]) { }
        field(11; "Serial No"; Code[20]) { }
        field(12; Email; Text[50]) { }
        field(13; "Tenderer Names"; Text[70]) { }
        field(14; "Telephone No"; Text[30]) { }
        field(15; "Witness Names"; Text[70]) { }
        field(16; "Tender Name"; Text[200]) { }
        field(17; "Posted To Portal"; Boolean) { }
        field(18; Year; Option)
        {
            OptionCaption = ' ,2014,2015,2016,2017,2018,2019,2020';
            OptionMembers = " ","2014","2015","2016","2017","2018","2019","2020";
        }
    }

    keys
    {
        key(Key1; "Tender ID", "TIN No.", "Receipt No.")
        {
            Clustered = true;
        }
        key(Key2; "Date Created") { }
        key(Key3; "TIN No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Error('You cannot delete data from this table');
    end;

    trigger OnInsert()
    begin
        "Date Created" := Today;
        "Created By" := UserId;
    end;
}

