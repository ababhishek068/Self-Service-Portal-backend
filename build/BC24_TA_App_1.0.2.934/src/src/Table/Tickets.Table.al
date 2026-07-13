Table 50360 Tickets
{

    fields
    {
        field(2; "Ticket Number"; Code[50])
        {
            Editable = false;
        }
        field(3; Customer; Code[50])
        {
            NotBlank = true;
            TableRelation = Customer."No." where("No." = field(Customer));
        }
        field(4; Status; Option)
        {
            OptionCaption = 'Open,Client Testing,Closed,Cancelled';
            OptionMembers = Open,"Client Testing",Closed,Cancelled;
        }
        field(5; Title; Text[100]) { }
        field(6; Description; Text[250]) { }
        field(7; "Assigned To"; Code[50])
        {
            TableRelation = "HR-Employee"."No." where("No." = field("Assigned To"));
        }
        field(8; "Date Raised"; DateTime) { }
        field(9; "Served By"; Code[50]) { }
        field(10; Resolution; Text[250]) { }
        field(11; Workaround; Text[250]) { }
        field(12; "Resolved By"; Code[10])
        {
            TableRelation = "HR-Employee"."No." where("No." = field("Resolved By"));
        }
        field(13; "No. Series"; Code[50]) { }
        field(14; "Date Resolved"; DateTime) { }
        field(15; "Priority Level"; Code[50])
        {
            TableRelation = "Priority Levels".Code;
        }
    }

    keys
    {
        key(Key1; "Ticket Number")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        //NextNo:=NoSeriesMgt.GetNextNo('TICKETNO',TODAY,TRUE);
        //"Ticket Number" := NextNo;
    end;
}

