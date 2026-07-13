Table 50492 "Purchase Quote Header"
{
    Caption = 'Purchase Quote Header';
    LookupPageID = "RFQ List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quotation Request,Open Tender,Restricted Tender,Low Value Procurement,Direct Procurement,Request for Proposal';
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender","Low Value Procurement","Direct Procurement","Request for Proposal";
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            Editable=false;
        }
        field(11; "Your Reference"; Text[30])
        {
            Caption = 'Your Reference';
        }
        field(12; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = Location.Code where("Use As In-Transit" = const(false));

            trigger OnValidate()
            begin
                if "Ship-to Code" <> '' then begin
                    location.Get("Ship-to Code");
                    "Location Code" := "Ship-to Code";
                    "Ship-to Name" := location.Name;
                    "Ship-to Name 2" := location."Name 2";
                    "Ship-to Address" := location.Address;
                    "Ship-to Address 2" := location."Address 2";
                    "Ship-to City" := location.City;
                    "Ship-to Contact" := location.Contact;
                end
            end;
        }
        field(13; "Ship-to Name"; Text[50])
        {
            Caption = 'Ship-to Name';
        }
        field(14; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(15; "Ship-to Address"; Text[50])
        {
            Caption = 'Ship-to Address';
        }

        field(16; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(17; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
        }
        field(18; "Ship-to Contact"; Text[50])
        {
            Caption = 'Ship-to Contact';
        }

        field(19; "Expected Opening Date"; DateTime)
        {
            Caption = 'Opening Date';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "Expected Closing Date"; DateTime)
        {
            Caption = 'Closing Date';
        }
        field(22; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(26; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(80;"Floating date";Date){}
        field(90; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(31; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            Editable = false;
            TableRelation = "Vendor Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            begin
            end;
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            //TableRelation = Language;
        }
        field(43; "Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            // TableRelation = "ary ca";

            trigger OnValidate()
            begin
            end;
        }
        field(45; "Order Class"; Code[10])
        {
            Caption = 'Order Class';
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = exist("Purch. Comment Line" where("Document Type" = field("Document Type"),
                                                             "No." = field("No."),
                                                             "Document Line No." = const(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(51; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(52; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account";
        }
        field(57; Receive; Boolean)
        {
            Caption = 'Receive';
        }
        field(58; Invoice; Boolean)
        {
            Caption = 'Invoice';
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Purchase Line".Amount where("Document No." = field("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Purchase Line"."Amount Including VAT" where("Document Type" = field("Document Type"),
                                                                            "Document No." = field("No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Receiving No."; Code[20])
        {
            Caption = 'Receiving No.';
        }
        field(63; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(64; "Last Receiving No."; Code[20])
        {
            Caption = 'Last Receiving No.';
            Editable = false;
            TableRelation = "Purch. Rcpt. Header";
        }
        field(65; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Purch. Inv. Header";
        }
        field(73; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(74; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(76; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(77; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            Caption = 'VAT Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(92; "Ship-to Region"; Text[30])
        {
            Caption = 'Ship-to Region';
        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(94; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(95; "Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';

            trigger OnValidate()
            begin
            end;
        }
        field(97; "Entry Point"; Code[10])
        {
            Caption = 'Entry Point';
            TableRelation = "Entry/Exit Point";
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(101; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(104; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(109; "Receiving No. Series"; Code[10])
        {
            Caption = 'Receiving No. Series';
            TableRelation = "No. Series";
        }
        field(114; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(115; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(116; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(118; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            begin
            end;
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
            end;
        }
        field(120; Status; Option)
        {
            Caption = 'Status';
            Editable = true;
            OptionCaption = 'Open,Released,Pending Approval,Closed,Cancelled,Stopped,Approved';
            OptionMembers = Open,Released,"Pending Approval",Closed,Cancelled,Stopped,Approved;
        }
        field(121; "Invoice Discount Calculation"; Option)
        {
            Caption = 'Invoice Discount Calculation';
            Editable = false;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122; "Invoice Discount Value"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
            Editable = false;
        }
        field(123; "Send IC Document"; Boolean)
        {
            Caption = 'Send IC Document';
        }
        field(124; "IC Status"; Option)
        {
            Caption = 'IC Status';
            OptionCaption = 'New,Pending,Sent';
            OptionMembers = New,Pending,Sent;
        }
        field(125; "Buy-from IC Partner Code"; Code[20])
        {
            Caption = 'Buy-from IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(126; "Pay-to IC Partner Code"; Code[20])
        {
            Caption = 'Pay-to IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(129; "IC Direction"; Option)
        {
            Caption = 'IC Direction';
            OptionCaption = 'Outgoing,Incoming';
            OptionMembers = Outgoing,Incoming;
        }
        field(151; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
        }
        field(152; "Has EOI"; Boolean)
        {
            Caption = 'Has EOI';
        }
        field(153; "EOI Stage"; Option)
        {
            OptionMembers = "Not yet Published","Published/Responses",Closed;
        }
        field(154; "Date Published"; DateTime)
        {
            Editable = false;
        }
        field(155; "Published By"; Code[20])
        {
            Editable = false;
        }
        field(5043; "No. of Archived Versions"; Integer)
        {
            CalcFormula = max("Purchase Header Archive"."Version No." where("Document Type" = field("Document Type"),
                                                                             "No." = field("No."),
                                                                             "Doc. No. Occurrence" = field("Doc. No. Occurrence")));
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(5052; "Buy-from Contact No."; Code[20])
        {
            Caption = 'Buy-from Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            begin
            end;

            trigger OnValidate()
            begin
            end;
        }
        field(5053; "Pay-to Contact No."; Code[20])
        {
            Caption = 'Pay-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            begin
            end;

            trigger OnValidate()
            begin
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";
        }
        field(5752; "Completely Received"; Boolean)
        {
            CalcFormula = min("Purchase Line"."Completely Received" where("Document Type" = field("Document Type"),
                                                                           "Document No." = field("No."),
                                                                           Type = filter(<> ' '),
                                                                           "Location Code" = field("Location Filter")));
            Caption = 'Completely Received';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5753; "Posting from Whse. Ref."; Integer)
        {
            Caption = 'Posting from Whse. Ref.';
        }
        field(5754; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5790; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
        }
        field(5791; "Promised Receipt Date"; Date)
        {
            Caption = 'Promised Receipt Date';
        }
        field(5792; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(5793; "Inbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Inbound Whse. Handling Time';
        }
        field(5796; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5801; "Return Shipment No."; Code[20])
        {
            Caption = 'Return Shipment No.';
        }
        field(5802; "Return Shipment No. Series"; Code[10])
        {
            Caption = 'Return Shipment No. Series';
            TableRelation = "No. Series";
        }
        field(5803; Ship; Boolean)
        {
            Caption = 'Ship';
        }
        field(5804; "Last Return Shipment No."; Code[20])
        {
            Caption = 'Last Return Shipment No.';
            Editable = false;
            TableRelation = "Return Shipment Header";
        }
        field(9000; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";
        }
        field(50000; "Supplier Category"; Code[20])
        {
            TableRelation = "Supplier Category".Code;

            trigger OnValidate()
            //Var
            //VendorCatego: Record "Vendor Category";
            begin
                VendorCatego.Reset;
                VendorCatego.SetRange(VendorCatego.Code, "Supplier Category");
                if VendorCatego.Find('-') then
                    "Supplier Category Description" := VendorCatego.Description;
            end;
        }
        field(50001; "Supplier Category Description"; Text[50]) { }
        field(50003; "Days to Deliver"; Code[100]) { }
        field(50004; Archived; Boolean) { }
        field(50005; "Quotation Vendor Limit"; Integer) { }
        field(50006; "Evaluation Committee"; Boolean) { }
        field(50007; "Product Category"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Product Categories"."Product Code" where(Status = filter(Active));
        }
        field(50008; "Sub Product Category"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Product Categories"."Sub Product Code" where(Status = filter(Active), "Product Code" = field("Product Category"));
        }
        field(39004240; Copied; Boolean) { }
        field(39004241; "Debit Note"; Boolean) { }
        field(39004243; "PRF No"; Code[10])
        {
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Quote),
                                                           Status = filter(Released));
            trigger OnLookup()
            begin
                PurchHeader.Reset;
                PurchHeader.SetRange(PurchHeader."Document Type", PurchHeader."document type"::Quote);
                PurchHeader.SetRange(PurchHeader.DocApprovalType, PurchHeader.Docapprovaltype::Requisition);
                PurchHeader.SetRange(PurchHeader.Status, PurchHeader.Status::Released);
                if Page.RunModal(53, PurchHeader) = Action::LookupOK then begin
                    "PRF No" := PurchHeader."No.";
                    Validate("PRF No");
                end
            end;

            trigger OnValidate()
            begin
                AutoPopPurchQuoteLine;
            end;
        }
        field(39004244; "Released By"; Code[50]) { }
        field(39004245; "Release Date"; Date) { }
        field(39004246; "Procuremet Methods"; Code[20])
        {
            TableRelation = "Procurement Methods";
        }
        field(39005536; Cancelled; Boolean) { }
        field(39005537; "Cancelled By"; Code[50]) { }
        field(39005538; "Cancelled Date"; Date) { }
        field(39005539; DocApprovalType; Option)
        {
            OptionMembers = Purchase,Requisition,Quote;
        }
        field(39005540; "Procurement Type Code"; Code[20])
        {
            TableRelation = "Store Requistion Header";
        }
        field(39005556; "Internal Requisition No."; Code[20])
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
                PurchQuoteLine.SetRange(PurchQuoteLine."Document No.", "No.");
                PurchQuoteLine.DeleteAll();
                //Delete same attachments
                DocumentAttachment.SetRange("Table ID", Database::"Purchase Quote Header");
                //DocumentAttachment.SetRange("Document Type", Rec."Document Type");
                 DocumentAttachment.SetRange("No.", Rec."Internal Requisition No.");
                if DocumentAttachment.FindSet() then begin
                repeat
                    DocumentAttachment.DeleteAll();
                until DocumentAttachment.Next=0;
                end;

                

                "Posting Description" := '';

                PurchHeader.Reset();
                PurchHeader.SetRange(PurchHeader."Document Type", PurchHeader."document type"::Quote);
                PurchHeader.SetRange(PurchHeader."No.", "Internal Requisition No.");
                if PurchHeader.Find('-') then begin
                    "Posting Description" := PurchHeader."Posting Description";
                    "Request Description" := PurchHeader."Request Description";
                    "Document Date" := PurchHeader."Posting Date";
                    "Posting Date" := PurchHeader."Posting Date";

                    Modify;
                end;

                PurchaseLine.Reset();
                PurchaseLine.SetRange(PurchaseLine."Document No.", "Internal Requisition No.");
                if PurchaseLine.Find('-') then begin
                    repeat
                        PurchQuoteLine.Init();

                        PurchQuoteLine."Document Type" := "Document Type";
                        PurchQuoteLine."Document No." := "No.";

                        PurchQuoteLine."Line No." := PurchaseLine."Line No.";
                        PurchQuoteLine.Type := PurchaseLine.Type;
                        PurchQuoteLine."Request Summary.":=PurchaseLine."Request Summary";

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
            DocumentAttachment1.User:="User ID";
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
        field(39005557; Remarks; Text[150]) { }
        field(39005558; "Certificate of Incorporation"; Boolean) { }
        field(39005559; "YAGPO Certificate"; Boolean) { }
        field(39005560; "Tax Compliance"; Boolean) { }
        field(39005561; "Description2"; text[200]) { }
        field(39005562; "Country of Origin"; text[200]) { }
        field(39005563; "Request Description"; text[200])
        {
            Editable = false;
        }
        field(39005564; "Purchase Requisition No."; code[20]) { 
            
        }
        field(39005565; "User ID"; code[20]) { }
        field(39005566; "Requisition Date"; date) { }
        field(51000; "Vendor No. Filter"; code[20])
        {
            FieldClass = flowfilter;
        }
        field(51001; "Requester name"; text[100]) { }
        field(51002; "Is request for proposal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51003; "Opening Committee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(99008501; "Time Received"; Time)
        {
            Caption = 'Time Received';
        }
        field(99008504; "BizTalk Purchase Quote"; Boolean)
        {
            Caption = 'BizTalk Purchase Quote';
        }
        field(99008505; "BizTalk Purch. Order Cnfmn."; Boolean)
        {
            Caption = 'BizTalk Purch. Order Cnfmn.';
        }
        field(99008506; "BizTalk Purchase Invoice"; Boolean)
        {
            Caption = 'BizTalk Purchase Invoice';
        }
        field(99008507; "BizTalk Purchase Receipt"; Boolean)
        {
            Caption = 'BizTalk Purchase Receipt';
        }
        field(99008508; "BizTalk Purchase Credit Memo"; Boolean)
        {
            Caption = 'BizTalk Purchase Credit Memo';
        }
        field(99008509; "Date Sent"; Date)
        {
            Caption = 'Date Sent';
        }
        field(99008510; "Time Sent"; Time)
        {
            Caption = 'Time Sent';
        }
        field(99008511; "BizTalk Request for Purch. Qte"; Boolean)
        {
            Caption = 'BizTalk Request for Purch. Qte';
        }
        field(99008512; "BizTalk Purchase Order"; Boolean)
        {
            Caption = 'BizTalk Purchase Order';
        }
        field(99008520; "Vendor Quote No."; Code[20])
        {
            Caption = 'Vendor Quote No.';
        }
        field(99008521; "BizTalk Document Sent"; Boolean)
        {
            Caption = 'BizTalk Document Sent';
        }
        field(5000; "Advertisement Date";Date){}
        field(5001;Advertised;Boolean){}
        field(5002;"Awarded to";code[20])
        {
            TableRelation=Bidders."Vendor Number" where ("Award Status"=filter(Awarded));
            Editable=false;
        }
        

    }



    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
        key(Key2; "No.", "Document Type") { }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Posting Description", "Requester name") { }
        fieldgroup(Brick; "Request Description", "User ID") { }
    }



    trigger OnDelete()
    begin
        //ERROR('Deletion of records not allowed');
    end;

    trigger OnInsert()
    var
        userRec: record user;
    begin
        //Check if the number has been inserted by the user
        if "No." = '' then begin
            PurchSetup.Reset;
            PurchSetup.Get();
            PurchSetup.TestField(PurchSetup."Quotation Request No");
            "No." := NoSeriesMgt.GetNextNo(PurchSetup."Quotation Request No", Today, true);
        end;
        userRec.reset;
        userrec.setrange("User Name", Database.UserId);
        if userRec.find('-') then
            "Requester name" := userRec."Full Name";

        "Assigned User ID" := UserId;
        "User ID" := UserId;
    end;

    trigger OnModify()
    begin
        TestField(Status, Status::Open);
        if xRec."No." <> "No." then begin
            PurchSetup.Get();
            NoSeriesMgt.TestManual(PurchSetup."Quotation Request No");
        end;
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit "No. Series";
        location: Record Location;
        PurchHeader: Record "Purchase Header";
        PurchQuoteLine: Record "Purchase Quote Line";
        PurchaseLine: Record "Purchase Line";
        bidder: record Bidders;
        //VendorCatego: Record "Supplier Category";
        VendorCatego: Record "Supplier Category";
        Text051: label 'If you change the Request for Quote No. the current lines will be deleted. Do you want to continue?';
        Item: Record Item;
        ItemUnitofMeasure: Record "Item Unit of Measure";

    procedure AutoPopPurchQuoteLine()
    var
        reqLine: Record "Purchase Line";
        PurchQuoteLine2: Record "Purchase Quote Line";
        LineNo: Integer;
    begin
        PurchQuoteLine2.SetRange("Document Type", "Document Type");
        PurchQuoteLine2.SetRange("Document No.", "No.");
        PurchQuoteLine2.DeleteAll;
        PurchQuoteLine2.Reset;




        //reqLine.SETRANGE(reqLine."Document Type","Document Type");
        reqLine.SetRange(reqLine."Document No.", "PRF No");

        if reqLine.Find('-') then begin
            PurchQuoteLine2.Init;
            repeat
                if reqLine.Quantity <> 0 then begin
                    LineNo := LineNo + 1000;
                    PurchQuoteLine2."Document Type" := "Document Type";
                    PurchQuoteLine2.Validate("Document Type");
                    PurchQuoteLine2."Document No." := "No.";
                    PurchQuoteLine2.Validate("Document No.");
                    PurchQuoteLine2."Line No." := LineNo;
                    PurchQuoteLine2.Type := reqLine.Type;
                    //PurchQuoteLine2."Expense Code" := reqLine."Expense Code";    //Denno added---
                    PurchQuoteLine2."No." := reqLine."No.";
                    PurchQuoteLine2.Validate("No.");
                    PurchQuoteLine2.Description := reqLine.Description;
                    PurchQuoteLine2.Quantity := reqLine.Quantity;
                    PurchQuoteLine2.Validate(Quantity);
                    PurchQuoteLine2."Unit of Measure Code" := reqLine."Unit of Measure Code";
                    PurchQuoteLine2.Validate("Unit of Measure Code");
                    PurchQuoteLine2."Unit of Measure" := reqLine."Unit of Measure";
                    PurchQuoteLine2."Direct Unit Cost" := reqLine."Direct Unit Cost";
                    PurchQuoteLine2.Validate("Direct Unit Cost");
                    PurchQuoteLine2."Location Code" := reqLine."Location Code";
                    PurchQuoteLine2."Location Code" := "Location Code";
                    PurchQuoteLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    PurchQuoteLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    PurchQuoteLine2.Insert(true);
                end
            until reqLine.Next = 0;
        end;
    end;
}

