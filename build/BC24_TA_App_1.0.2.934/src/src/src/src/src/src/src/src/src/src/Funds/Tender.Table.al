Table 50494 Tender
{

    fields
    {
        field(1; "Tender ID"; Code[20]) { editable=false;}
        field(2; Description; Text[250]) { }
        field(3; "Date Created"; Date) { }
        field(4; "Created By"; Code[20]) { }
       
            field(10; "Internal Requisition No."; Code[20])
           {
            TableRelation = "Purchase Header"."No." where(Status = filter(Released));

            
            trigger OnValidate()
            var
            DocumentAttachment: Record "Document Attachment";
            DocumentAttachment1: Record "Document Attachment";
            begin
                //CHECK WHETHER HAS LINES AND DELETE
                if not Confirm(Text051, false) then Error('You have selected to abort the process');

                PurchQuoteLine.Reset();
                PurchQuoteLine.SetRange(PurchQuoteLine."Document No.", "Tender ID");
                PurchQuoteLine.DeleteAll();
                DocumentAttachment.SetRange("Table ID", Database::"Purchase Quote Header");
                //DocumentAttachment.SetRange("Document Type", Rec."Document Type");
                 DocumentAttachment.SetRange("No.", Rec."Internal Requisition No.");
                if DocumentAttachment.FindSet() then begin
                repeat
                    DocumentAttachment.DeleteAll();
                until DocumentAttachment.Next=0;
                end;

                //Delete same attachments

                //"Posting Description" := '';

                PurchHeader.Reset();
                PurchHeader.SetRange(PurchHeader."Document Type", PurchHeader."document type"::Quote);
                PurchHeader.SetRange(PurchHeader."No.", "Internal Requisition No.");
                if PurchHeader.Find('-') then begin
                    // "Posting Description" := PurchHeader."Posting Description";
                    // "Request Description" := PurchHeader."Posting Description";
                    // "Document Date" := PurchHeader."Posting Date";
                    // "Posting Date" := PurchHeader."Posting Date";

                    Modify;
                end;

                PurchaseLine.Reset();
                PurchaseLine.SetRange(PurchaseLine."Document No.", "Internal Requisition No.");
                if PurchaseLine.Find('-') then begin
                    repeat
                        PurchQuoteLine.Init();

                        PurchQuoteLine."Document Type" := PurchQuoteLine."Document Type"::"Open Tender";
                        PurchQuoteLine."Document No." := "Tender ID";

                        PurchQuoteLine."Line No." := PurchaseLine."Line No.";
                        PurchQuoteLine.Type := PurchaseLine.Type;

                        PurchQuoteLine."No." := PurchaseLine."No.";
                        if PurchQuoteLine.Type = PurchQuoteLine.Type::Item then begin
                            if Item.Get(PurchQuoteLine."No.") then begin
                                ItemUnitofMeasure.Reset();
                                ItemUnitofMeasure.SetRange(ItemUnitofMeasure."Item No.", Item."No.");
                                if ItemUnitofMeasure.Find('-') then PurchQuoteLine."Unit of Measure" := ItemUnitofMeasure.Code;
                            end;
                        end;

                        //PurchQuoteLine."Expense Code" := PurchaseLine."Expense Code";

                        PurchQuoteLine.Validate("No.");

                        PurchQuoteLine."Location Code" := PurchaseLine."Location Code";
                        PurchQuoteLine.Validate("Location Code");

                        PurchQuoteLine.Quantity := PurchaseLine.Quantity;
                        PurchQuoteLine.Validate(Quantity);

                        PurchQuoteLine."Direct Unit Cost" := PurchaseLine."Direct Unit Cost";
                        PurchQuoteLine.Validate("Direct Unit Cost");

                        PurchQuoteLine.Amount := PurchaseLine."Line Amount";
                        PurchQuoteLine."Unit Cost" := PurchaseLine."Line Amount";
                        PurchQuoteLine."Unit of Measure Code" := PurchaseLine."Unit of Measure";
                        //PurchQuoteLine.Description:=PurchaseLine."Description 2";
                        //PurchQuoteLine."Expense Code" := PurchaseLine."Expense Code";

                        PurchQuoteLine."Request Summary." := PurchaseLine."Request Summary";
                        PurchQuoteLine."Shortcut Dimension 1 Code" := PurchaseLine."Shortcut Dimension 1 Code";
                        PurchQuoteLine."Shortcut Dimension 2 Code" := PurchaseLine."Shortcut Dimension 2 Code";

                        PurchQuoteLine.Insert;
                    until PurchaseLine.Next = 0;
                end;

                  //insert attachments too

    DocumentAttachment.SetRange("Table ID", Database::"Purchase Header");
    //DocumentAttachment.SetRange("Document Type", Rec."Document Type");
    DocumentAttachment.SetRange("No.", Rec."Internal Requisition No.");

    if DocumentAttachment.FindSet() then begin
        repeat
            // Create a new attachment record for the Posted Purchase Invoice
            // In a real-world scenario, you would copy the actual file data as well
            DocumentAttachment1.Init();
            DocumentAttachment1."Table ID" := Database::"Purchase Quote Header";            
            DocumentAttachment1."Document Type" := DocumentAttachment."Document Type";
            DocumentAttachment1."No." := DocumentAttachment."No.";
            DocumentAttachment1.User:=UserId;
            DocumentAttachment1."Document Description":=DocumentAttachment."Document Description";
            DocumentAttachment1."File Type":=DocumentAttachment."File Type";
            DocumentAttachment1."File Extension":=DocumentAttachment."File Extension";
            DocumentAttachment1."File Name":=DocumentAttachment."File Name";
            DocumentAttachment1."Attached By":=DocumentAttachment."Attached By";
            DocumentAttachment1."Attached Date":=DocumentAttachment."Attached Date";
            DocumentAttachment1."Document Category":=DocumentAttachment."Document Category";
            DocumentAttachment1."Document Reference ID":=DocumentAttachment."Document Reference ID";

            // Other fields...
            DocumentAttachment1.Insert(true);
        until DocumentAttachment.Next() = 0;
    end;




            end;
        
        }
        field(5; "Tender Type"; Option)
        {
            OptionCaption = 'General,Pharmaceutical,Food Supplies,Services';
            OptionMembers = General,Pharmaceutical,"Food Supplies",Services;
        }
        field(6; Open; Boolean) { }
        field(7; Category; Option)
        {
            OptionCaption = 'Services and Consumables,Specialised Medical Equipment';
            OptionMembers = "Services and Consumables","Specialised Medical Equipment";
        }
        field(8; "Valid From"; Date) { }
        field(9; "Valid To"; Date) { }
    }

    keys
    {
        key(Key1; "Tender ID")
        {
            Clustered = true;
        }
        key(Key2; Category) { }
        key(Key3; "Tender Type") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Error('You cannot delete data from this table');
    end;

    trigger OnInsert()
    var
        userRec: record user;
    begin
        //Check if the number has been inserted by the user
        if "Tender ID" = '' then begin
            PurchSetup.Reset;
            PurchSetup.Get();
            PurchSetup.TestField(PurchSetup."Tender Bid Nos");
            "Tender ID" := NoSeriesMgt.GetNextNo(PurchSetup."Tender Bid Nos", Today, true);
        end;
        userRec.reset;
        userrec.setrange("User Name", Database.UserId);
        if userRec.find('-') then
            //"Requester name" := userRec."Full Name";

        "Date Created":=Today;
        "Created By":=UserId;
    end;

    var
        PurchHeader: Record "Purchase Header";
        NoSeriesMgt: Codeunit "No. Series";
        PurchQuoteLine: Record "Purchase Quote Line";
        ItemUnitofMeasure: Record "Item Unit of Measure";
        PurchaseLine: Record "Purchase Line";
        PurchSetup: Record "Purchases & Payables Setup";
        Item: Record Item;
        Text051: label 'If you change the Request for Quote No. the current lines will be deleted. Do you want to continue?';

}

