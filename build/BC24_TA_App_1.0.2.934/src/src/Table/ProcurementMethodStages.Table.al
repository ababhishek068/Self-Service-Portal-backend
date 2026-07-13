table 50539 "Procurement Method Stages"
{


    fields
    {
        field(1; "Procurement Method"; Option) { 
            OptionCaption = 'Quotation Request,Open Tender,Restricted Tender,Low Value Procurement,Direct Procurement,Request for Proposal,EOI';
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender","Low Value Procurement","Direct Procurement","Request for Proposal",EOI;

        }

        field(2; "Stage Code"; Code[20]) { }

        field(3; "Stage Description"; Text[50]) { }

        field(4; "Maximum Duration"; DateFormula) { }

        field(5; "Minimum Duration"; DateFormula) { }
    }

    keys
    {
        key(Key1; "Stage Code", "Procurement Method") { }
    }

    fieldgroups { }
}

