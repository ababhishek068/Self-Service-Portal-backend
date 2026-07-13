table 50976 "Tender Extension"
{
    Caption = 'Tender Extension';
    DataClassification = ToBeClassified;
    DrillDownPageId="Tender extension List";
    
    fields
    {
        field(1; "Req No"; Code[20])
        {
            Caption = 'Req No';
            Editable=false;
        }

        field(2; "Tender No"; Code[20])
        {
            Caption = 'Tender No';
            TableRelation="Purchase Quote Header"."No.";
            //TableRelation="Purchase Quote Header"."No." where(Status=const(Approved));
            trigger OnValidate()
            var

            tenderlist: Record "Purchase Quote Header";
            begin
                //TestField("Tender Type");
                Clear("Tender Name");
                Clear("Original Closing Date");
                Clear("Original Opening date");
                tenderlist.Reset();
                tenderlist.SetRange(tenderlist."No.","Tender No");
                if tenderlist.FindFirst() then begin
                
                    "Tender Name":=tenderlist."Request Description";
                    "Original Opening date":=tenderlist."Expected Opening Date";
                    "Tender Type":=tenderlist."Document Type";
                    "Original Closing Date":=tenderlist."Expected Closing Date";
                end;

                
                
            end;

        }
        field(3; "Tender Name"; Text[100])
        {
            Caption = 'Tender Name';
        }
        field(4; "Original Opening date"; DateTime)
        {
            Caption = 'Original Opening date';
            Editable=false;
        }
        field(5; "Proposed Opening Date"; DateTime)
        {
            Caption = 'Proposed Opening Date';
        }
        field(6; Justification; Text[1000])
        {
            Caption = 'Justification';
        }
        field(7; Reason; Option)
        {
            Caption = 'Reason';
            OptionMembers="","Shortage of Time","Technical Clarification";
        }
        field(8; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable=false;
        }
        field(9; Status; Option)
        {
            Caption = 'Status';
            OptionMembers=Open,"Pending Approval",Approved,Rejected;
        }
        field(10; "Date Created"; Date)
        {
            Caption = 'Date Created';
            Editable=false;
        }
        field(11; "Date Approved"; Date)
        {
            Caption = 'Date Approved';
            Editable=false;
        }
        field(12; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
            Editable=false;
        }
        field(13;"Tender Type";Option)
        {

            OptionMembers = "Quotation Request","Open Tender","Restricted Tender","Low Value Procurement","Direct Procurement","Request for Proposal";
        }
        field(14;"Original Closing Date";DateTime){
            Editable=false;

        }
        field(15;"Proposed Closing Date";Date){}
    }
    keys
    {
        key(PK; "Req No","Tender No")
        {
            Clustered = true;
        }

        
    }

    trigger OnInsert()
    var
        userRec: record user;
    begin
        //Check if the number has been inserted by the user
        if "Req No" = '' then begin
            PurchSetup.Reset;
            PurchSetup.Get();
            PurchSetup.TestField(PurchSetup."Quotation Request No");
            "Req No"  := NoSeriesMgt.GetNextNo(PurchSetup."Quotation Request No", Today, true);
        end;
        userRec.reset;
        userrec.setrange("User Name", Database.UserId);
        if userRec.find('-') then
            "Created By" := userRec."Full Name";
            "Date Created":=Today;
       
    end;

    trigger OnModify()
    begin
        TestField(Status, Status::Open);
        if xRec."Req No"  <> "Req No"  then begin
            PurchSetup.Get();
            NoSeriesMgt.TestManual(PurchSetup."Quotation Request No");
        end;
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit "No. Series";

}
