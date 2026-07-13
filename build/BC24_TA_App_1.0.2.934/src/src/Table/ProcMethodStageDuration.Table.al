table 50204 "Proc. Method Stage Duration"
{

    fields
    {
        field(1; "Proc. Method No."; Option) { 
             OptionCaption = 'Quotation Request,Open Tender,Restricted Tender,Low Value Procurement,Direct Procurement,Request for Proposal,EOI';
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender","Low Value Procurement","Direct Procurement","Request for Proposal",EOI;
        }
        field(2; Stage; Code[20])
        {

            trigger OnValidate()
            begin
                StagesRec.RESET();
                 StagesRec.GET(Stage);
                 Description:= StagesRec."Stage Description";
                 

            end;
        }
        field(3; "Duration(Days)"; Integer) { }
        field(4; "Sorting No."; Integer)
        {

            trigger OnValidate()
            begin
                /*
                me.SETRANGE("Sorting No.","Sorting No.");
                me.SETRANGE("Proc. Method No." ,"Proc. Method No.");
                IF me.COUNT>1 THEN ERROR('Sorting number must be unique!');
                */

            end;
        }
        field(5; Description; Text[50]) { }
    }

    keys
    {
        key(Key1; Stage, "Proc. Method No.")
        {
            Clustered = true;
        }
        key(Key2; "Sorting No.") { }
    }

    fieldgroups { }
    var
    StagesRec: Record "Procurement Method Stages";
}

