table 50216 "Tender Bids"
{

    fields
    {
        field(1; "Bid Reference"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Tender No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Bidder No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Bidder Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Date Submitted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Time Submitted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Open,Submitted,Under Review,Won,Lost,Cancelled';
            OptionMembers = ,Open,Submitted,"Under Review",Won,Lost,Cancelled;
        }
        field(9; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Last Modified By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Bid Reference")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        ERROR('You cannot delete this entry');
    end;

    trigger OnInsert()
    begin
        "Last Modified By" := USERID;
        "Last Modified Date" := CREATEDATETIME(TODAY, TIME);
    end;

    trigger OnModify()
    begin
        "Last Modified By" := USERID;
        "Last Modified Date" := CREATEDATETIME(TODAY, TIME);
    end;
}

