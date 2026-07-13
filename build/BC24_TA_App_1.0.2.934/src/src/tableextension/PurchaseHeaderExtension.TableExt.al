/// <summary>
/// TableExtension Purchase Header Extension (ID 70134691) extends Record Purchase Header.
/// </summary>
tableextension 50004 "Purchase Header Extension" extends "Purchase Header"
{

    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Pay-to Name"(Field 5)".

        modify("Pay-to Name 2")
        {
            TableRelation = Vendor;
        }

        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center BR".Code;
        }
        // modify(Status)
        // {
        //     editable = false;
        // }

        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                "Posting Description" := '';
            end;

            trigger OnBeforeValidate()
            begin
                "Posting Description" := '';
            end;
        }
        modify("Vendor Shipment No."){
            trigger OnAfterValidate()
            begin
                
                //check if already posted
                postship.Reset();
                postship.SetRange(postship."Order No.",Rec."No.");
                postship.SetRange(postship."Vendor Shipment No.",rec."Vendor Shipment No.");
                postship.SetRange(postship."Buy-from Vendor No.",rec."Buy-from Vendor No.");
                if postship.Find('-') then begin

                    Error('This Vendor Delivery Note number has been used');
                end;              

                    
                

                

            end;
        }

        field(50000; Copied; Boolean) { }
        field(50001; "Debit Note"; Boolean) { }
        field(50002; "Procurement Request No."; Code[20]) { }
        field(50003; "Invoice Amount"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Line Amount" where("Document Type" = field("Document Type"),
                                                                   "Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Request No"; Code[10]) { }
        field(50006; Commited; Boolean) { }
        field(50007; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));
        }
        field(50008; "Delivery No"; Code[15]) { }
        field(50009; "Ledger Card No"; Code[15]) { }
        field(50010; "PRN No"; Code[15]) { }
        field(50011; "Approval Status"; Option)
        {
            OptionCaption = 'New,Purchasing,Finance,Admin,Completed';
            OptionMembers = New,Purchasing,Finance,Admin,Completed;
        }
        field(50012; "PO Status"; Option)
        {
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(50013; "Finance Status"; Option)
        {
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(50014; "Admin Status"; Option)
        {
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(50015; "P.O Name"; Code[15]) { }
        field(50016; "P.O Approval Date"; Date) { }
        field(50017; "Finance Approved By"; Code[15]) { }
        field(50018; "Finance Approval Date"; Date) { }
        field(50019; "Admin Approved By"; Code[15]) { }
        field(50020; "Admin Approved Date"; Date) { }
        field(50021; "Contract No."; Code[15])
        {
            TableRelation = Contract."Contract Reference No" where(Active = filter('Yes'));
        }
        field(50022; "Quotation No."; Code[55]) { }
        field(50033; "Request for Quote No."; Code[20])
        {
            TableRelation = "Purchase Quote Header"."No." where(Status = const(Released));

            trigger OnValidate()
            begin
                //CHECK WHETHER HAS LINES AND DELETE
                if not Confirm('If you change the Request for Quote No. the current lines will be deleted. Do you want to continue?', false)
                then
                    Error('You have selected to abort the process');

                PurchLine.Reset;
                PurchLine.SetRange(PurchLine."Document No.", "No.");
                PurchLine.DeleteAll;

                RFQ.Reset;
                RFQ.SetRange(RFQ."Document No.", "Procurement Request No.");
                if RFQ.Find('-') then begin
                    repeat
                        PurchLine.Init;
                        PurchLine."Document Type" := "Document Type";
                        PurchLine."Document No." := "No.";
                        PurchLine."Line No." := RFQ."Line No." + 5;
                        PurchLine.Type := RFQ.Type;
                        //  PurchLine."Document Type 2":="Document Type 2";
                        PurchLine."No." := RFQ."No.";
                        PurchLine.Validate("No.");
                        PurchLine."Location Code" := RFQ."Location Code";
                        PurchLine.Validate("Location Code");
                        PurchLine.Quantity := RFQ.Quantity;
                        PurchLine."Description 2" := RFQ."Description 2";
                        PurchLine.Validate(Quantity);
                        PurchLine."Direct Unit Cost" := RFQ."Direct Unit Cost";
                        PurchLine.Validate("Direct Unit Cost");
                        PurchLine.Amount := RFQ.Amount;
                        PurchLine.Insert;
                    until RFQ.Next = 0;
                end;
            end;
        }
        field(50034; "Document Type 2"; Option)
        {
            OptionMembers = Requisition,Quote,"Order";
        }
        field(50035; "Repair No"; Code[20])
        {
            TableRelation = "Asset Repair Header"."Request No.";
        }
        field(50040; "Tendor Number"; Code[30])
        {
            TableRelation = "Tender Plan Header"."No.";
        }
        field(50041; Allocation; Decimal) { }
        field(50042; Expenditure; Decimal) { }
        field(50043; "Purchase Type"; Option)
        {
            OptionCaption = ' ,Departmental,Global';
            OptionMembers = " ",Departmental,Global;
        }
        field(50045; "Budgeted Amount"; Decimal)
        {
            Editable = false;
        }
        field(50046; "Actual Expenditure"; Decimal)
        {
            Editable = false;
        }
        field(50047; "Committed Amount"; Decimal)
        {
            Editable = false;
        }
        field(50048; "Budget Balance"; Decimal)
        {
            Editable = false;
        }
        field(50049; "Reference No"; Code[30])
        {
            TableRelation = if ("Refrence Type" = const(Employee)) "HR-Employee"."No."
            else
            if ("Refrence Type" = const(Student)) Customer."No." where("Customer Posting Group" = const('STUDENT'));
        }
        field(50050; "Refrence Type"; Option)
        {
            OptionCaption = 'Employee,Student';
            OptionMembers = Employee,Student;
        }
        field(50061; "Quote Comments"; Text[100])
        {
            Description = 'Store Comments of Purchase Quote in the DB (Added)';
        }
        field(50062; "Responsibility Center Name"; Text[100])
        {
            Description = 'Stores Responsibilty Center Name in the database (Added)';
        }
        field(50063; "Donor Name"; Text[50])
        {
            Description = 'Stores Donor Name in the database (Added)';
        }
        field(50064; "Pillar Name"; Text[50])
        {
            Description = 'Stores Pillar Name in the database (Added)';
        }
        field(50065; "Quote Comments 2"; Text[100]) { }
        field(50066; "Quote Comments 3"; Text[100])
        {
            Enabled = false;
        }
        field(50067; "Recommendation 1"; Text[100]) { }
        field(50068; "Recommendation 2"; Text[100]) { }
        field(50069; "Project Code"; Code[10]) { }
        field(50070; "Archive Unused Doc"; Boolean) { }
        field(50071; "VAT Method"; Option)
        {
            OptionCaption = 'Expensed,Recovered';
            OptionMembers = Expensed,Recovered;
        }
        field(50072; "Department Name"; Text[100])
        {
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Shortcut Dimension 2 Code")));
            FieldClass = FlowField;
        }
        field(31409336; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(31409337; text; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(39005536; Cancelled; Boolean)
        {
            Editable = false;
        }
        field(39005537; "Cancelled By"; Code[20]) { }
        field(39005538; "Cancelled Date"; Date) { }

        field(39005540; "Procurement Type Code"; Code[20])
        {
            // TableRelation = "Procurement Limit Code"."Procurement Code";
        }
        field(39005541; "Invoice Basis"; Option)
        {
            OptionMembers = "PO Based","Direct Invoice";
        }
        field(39005544; "RFQ No."; Code[20])
        {

            //Add filter dimensions -felix
            //TableRelation = "Purchase Quote Header"."No." where(Status = const(Released));
            TableRelation = "Purchase Quote Header"."No.";

            trigger OnValidate()
            var
                RFQHeader: Record "Purchase Quote Header";
                RFQLines: Record "Purchase Quote Line";
            begin
                // TestField("Responsibility Center");
                // TestField("Shortcut Dimension 1 Code");
                // TestField("Shortcut Dimension 2 Code");
                //Felix-add later

                PurchLine.RESET;
                PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::Quote);
                PurchLine.SETRANGE(PurchLine."Document No.", "No.");
                IF NOT PurchLine.ISEMPTY() THEN BEGIN
                    IF NOT CONFIRM('If you change the Request for Quote No. the current lines will be deleted. Do you want to continue?', FALSE) THEN ERROR('You have selected to abort the process');

                    PurchLine.RESET();
                    PurchLine.SETRANGE(PurchLine."Document No.", "No.");
                    PurchLine.DELETEALL();
                END;

                RFQLines.RESET;
                RFQLines.SETRANGE(RFQLines."Document No.", "RFQ No.");
                IF RFQLines.FIND('-') THEN BEGIN
                    REPEAT
                        PurchLine.RESET;

                        PurchLine.INIT;

                        PurchLine."Document Type" := "Document Type";
                        PurchLine."Document No." := "No.";

                        PurchLine."Line No." := RFQLines."Line No.";

                        PurchLine.Type := RFQLines.Type;

                        PurchLine."No." := RFQLines."No.";

                        //PurchLine."Expense Code" := RFQLines."Expense Code";

                        PurchLine.VALIDATE("No.");

                        PurchLine."Location Code" := RFQLines."Location Code";
                        PurchLine.VALIDATE("Location Code");

                        PurchLine.Quantity := RFQLines.Quantity;
                        PurchLine.VALIDATE(Quantity);

                        PurchLine."Direct Unit Cost" := RFQLines."Direct Unit Cost";
                        PurchLine.VALIDATE("Direct Unit Cost");

                        PurchLine.Amount := RFQLines.Amount;
                        PurchLine."Request Summary" := RFQLines."Request Summary.";

                        PurchLine.INSERT;
                    UNTIL RFQLines.NEXT = 0;
                END;

                CLEAR("Request Description");
                //CLEAR("Shortcut Dimension 1 Code");
                //CLEAR("Shortcut Dimension 2 Code");
                //CLEAR("Responsibility Center");
                //felix-add later
                CLEAR("Requisition No.");
                CLEAR("Assigned User ID");

                RFQHeader.RESET();
                RFQHeader.SETRANGE(RFQHeader."No.", "RFQ No.");
                IF RFQHeader.FIND('-') THEN BEGIN
                    "Request Description" := RFQHeader."Posting Description";

                    // "Assigned User ID" := RFQHeader."Assigned User ID";

                    "Shortcut Dimension 1 Code" := RFQHeader."Shortcut Dimension 1 Code";
                    //VALIDATE("Shortcut Dimension 1 Code");

                    "Shortcut Dimension 2 Code" := RFQHeader."Shortcut Dimension 2 Code";
                    //VALIDATE("Shortcut Dimension 2 Code");

                    "Responsibility Center" := RFQHeader."Responsibility Center";
                    //VALIDATE("Responsibility Center");

                    //Load Internal purchase
                    "Requisition No." := RFQHeader."Internal Requisition No.";

                    //  MODIFY;
                END;
            end;
        }
        field(39005550; "Expiry Date"; Date) { }
        field(39005551; "Special Remark"; Text[20]) { }
        field(39005552; "Responsible Officer"; Code[20])
        {
            TableRelation = "User Setup" where("Procurement Officer" = filter(true));
        }
        field(39005553; Type; Option)
        {
            OptionCaption = ' ,LPO,LSO';
            OptionMembers = " ",LPO,LSO;
        }
        field(39005554; "Imprest Purchase Doc No"; Code[20]) { }
        field(39005555; "Manual LPO No."; Code[20]) { }
        field(39005556; "Requisition No."; Code[20])
        {
            CalcFormula = lookup("Purchase Line"."Requisition No" where("Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(39005557; "LPO No."; Code[20]) { }
        field(39005558; Contract; Boolean)
        {

            trigger OnValidate()
            begin
                CalcFields("Invoice Amount");
                if "Invoice Amount" < 1000000 then Error('Please note that contract LPO is only applicable for LPOs with a value of 1million and above');
                Status := Status::Released;
            end;
        }
        field(39005559; "Employee No."; Code[20])
        {
            TableRelation = "HR-Employee";
        }
        field(39005560; "LPO Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Cash LPO,Normal LPO';
            OptionMembers = "Cash LPO","Normal LPO";
        }
        field(80000; DocApprovalType; Option)
        {
            Caption = 'DocApprovalType';
            OptionMembers = "",Purchase,Requisition,Quote;
            DataClassification = ToBeClassified;
        }

        field(80001; "Request Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Request Description';
        }

        field(80002; "Procurement Method Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Procurement Method Code';
            TableRelation = "Procurement Methods".Code;
        }

        field(80003; "Requestor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Requestor ID';
            Editable = false;
        }
        field(51003; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = 'Department';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(50751; "Serviced Orders"; Boolean)
        {
            CalcFormula = Exist("Purchase Line" WHERE("Document Type" = FIELD("Document Type"),
                                                       "Document No." = FIELD("No."),
                                                       Type = FILTER(<> " "),
                                                       "Location Code" = FIELD("Location Filter"),
                                                       "Quantity Received" = FILTER(> 0)));
            Caption = 'Serviced Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50165; "Used in RFQ"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Quote Header" where("PRF No" = field("No."), Status = filter(Released)));
        }
        field(50166; "Is HOD"; Boolean) { }
        field(50167; "Vessel No"; code[20]) { }
        field(50168; "Lading No"; code[20]) { }
        field(50169; "Lading Date"; date) { }
        field(50170; "Expected Closing Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(50106; "Purchase Requisition No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." where(DocApprovalType = filter(Requisition), Status = filter(Released));
            trigger OnValidate()
            var
                PurchLine: Record "Purchase Line";
                PurchLine2: Record "Purchase Line";
                ln: Integer;
            begin
                PurchLine.Reset();
                PurchLine.SetRange("Document No.", "No.");
                if PurchLine.Find('-') then begin
                    if confirm('There are some existing lines for document ' + "No." + '. Do you want to proceed?', false) = true then begin
                        PurchLine.DeleteAll();
                    end;
                end;
                PurchLine2.Reset();
                PurchLine2.SetRange("Document No.", "Purchase Requisition No.");
                //PurchLine2.SetRange("Document Type 2", "Document Type 2"::Requisition);
                if PurchLine2.Find('-') then begin
                    repeat
                        ln := ln + 1;
                        PurchLine.Init;
                        PurchLine."Line No." := PurchLine."Line No." + ln;
                        PurchLine."Document No." := "No.";
                        PurchLine.Type := PurchLine2.Type;
                        PurchLine."Document Type" := PurchLine."Document Type"::Order;
                        PurchLine."Document Type 2" := PurchLine."Document Type 2"::Order;
                        PurchLine."No." := PurchLine2."No.";
                        PurchLine.Validate("No.");
                        PurchLine.Description := PurchLine2.Description;
                        PurchLine."Description 2" := PurchLine2."Description 2";
                        PurchLine."Request Summary" := PurchLine2."Request Summary";
                        PurchLine."Description 3" := PurchLine2."Description 3";
                        PurchLine.Quantity := PurchLine2.Quantity;
                        PurchLine.Amount := PurchLine2.Amount;
                        PurchLine."Unit of Measure" := PurchLine2."Unit of Measure";
                        PurchLine."Posting Group" := PurchLine2."Posting Group";
                        PurchLine.Insert();
                    until PurchLine2.Next() = 0;
                end

                else begin

                    PurchLine2.Reset();
                    PurchLine2.SetRange("Document No.", "Purchase Requisition No.");
                    PurchLine2.SetRange(PurchLine2."Document Type 2", PurchLine2."Document Type 2"::Requisition);
                    if PurchLine2.Find('-') then begin
                        repeat
                            ln := ln + 1;
                            PurchLine.Init;
                            PurchLine."Line No." := PurchLine."Line No." + ln;
                            PurchLine."Document No." := "No.";
                            PurchLine.Type := PurchLine2.Type;
                            PurchLine."No." := PurchLine2."No.";
                            PurchLine.Validate("No.");
                            PurchLine."Document Type" := PurchLine."Document Type"::Order;
                            PurchLine."Document Type 2" := PurchLine."Document Type 2"::Order;
                            PurchLine.Description := PurchLine2.Description;
                            PurchLine."Description 2" := PurchLine2."Description 2";
                            PurchLine."Description 3" := PurchLine2."Description 3";
                            PurchLine.Quantity := PurchLine2.Quantity;
                            PurchLine.Amount := PurchLine2.Amount;
                            PurchLine."Unit of Measure" := PurchLine2."Unit of Measure";
                            PurchLine."Posting Group" := PurchLine2."Posting Group";
                            PurchLine.Insert();
                        until PurchLine2.Next() = 0;
                    end;
                end;
            end;
        }
        field(50107; "Assigned Procurement Officer"; Code[20])
        {
            TableRelation = "Hr-Employee"."No." where("Procurement Officer" = const(true));
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
                UserSetup: Record "User Setup";
            begin
                if UserSetup.Get(UserId)
then begin
                    if UserSetup."Procurement Officer" = false then Error('You do not have permission to assign a procurement officer');
                    if HREmp.Get("Assigned Procurement Officer") THEN
                        "Procurement Officer UserID" := HREmp."User ID";
                end else
                    Error('You cannot assign a procurement officer');

            end;
        }
        field(51123; "Procurement Officer UserID"; Code[20])
        {
            TableRelation = "User Setup";
        }
        field(50108; "Openning and Closing Date"; Date) { }
        field(50109; "Evaluation Date"; Date) { }
        field(50110; "Notification Award Date"; Date) { }
        field(50111; "Opinion No"; Code[20]) { }
        field(50112; "Procurement Method"; Code[20]) { }
        field(50113; "Scheme Applied"; Code[20]) { }
        field(50114; "Nature of Contract"; Code[20]) { }
        field(50115; "Tender Award Date"; Date) { }
        field(50116; "Tender Category"; Code[20]) { }
        field(50117; "Contract Completion Date"; Date) { }
        field(50118; "Date of Contract"; Date) { }
        field(70134683; "Imprest Memo No"; code[20])
        {
            TableRelation = "Imprest Memo Header"."No." where(Status = filter(Approved));
            trigger OnValidate()
            var
                CashOffice: record "Cash Office Setup";
                ImpMemo: Record "Imprest Memo Header";
                ImpMemoLine: record "Imprest Memo Lines";
                objPurchaseLine: record "Purchase Line";
            begin
                if CashOffice.Get() then
                    if CashOffice."Enable Imprest Memo" = true then begin
                        TestField("Imprest Memo No");
                        if ImpMemo.get("Imprest Memo No") then begin
                            // Purpose := ImpMemo.Purpose;

                            ImpMemoLine.reset;
                            ImpMemoLine.setrange(ImpMemoLine.No, "Imprest Memo No");
                            ImpMemoLine.SetRange(ImpMemoLine."Imprest Type", ImpMemoLine."Imprest Type"::ItemCash);
                            if ImpMemoLine.find('-') then begin
                                objPurchaseLine.init;
                                objPurchaseLine."Document No." := "No.";
                                objPurchaseLine."Line No." := ImpMemoLine."Line No.";
                                objPurchaseLine."No." := ImpMemo."Account No.";
                                objPurchaseLine."Document Type" := objPurchaseLine."Document Type"::Quote;
                                objPurchaseLine."Document Type 2" := objPurchaseLine."Document Type 2"::Requisition;
                                objPurchaseLine.Type := objPurchaseLine.Type::Item;
                                objPurchaseLine.Validate(objPurchaseLine."No.");
                                objPurchaseLine.Quantity := ImpMemoLine.Quantity;
                                objPurchaseLine."Location Code" := "Location Code";
                                objPurchaseLine.Validate(objPurchaseLine.Quantity);
                                objPurchaseLine."Direct Unit Cost" := ImpMemoLine.Amount;
                                objPurchaseLine.Validate("Direct Unit Cost");
                                objPurchaseLine."Description 2" := ImpMemoLine."Account Name";
                                objPurchaseLine.Amount := ImpMemoLine.Amount;
                                objPurchaseLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                objPurchaseLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                objPurchaseLine.insert;
                            end;
                        end;

                    end;
            end;

        }
        field(50119; "Reason For Termination"; Text[500])
        {
            trigger OnValidate()
            begin
                "Terminated By" := Database.UserId;
                "Date of Termination" := Today;
            end;
        }
        field(50120; "Date of Termination"; Date) { }
        field(50121; "Terminated By"; Code[50]) { }
        field(50122; "User ID Filter"; Code[30])
        {
            FieldClass = FlowFilter;
        }
    }

    fieldgroups
    {
        addlast(DropDown; "Posting Description") { }
        addlast(DropDown; "Assigned User ID") { }
        addlast(DropDown; "Requestor Name") { }
    }
    trigger OnAfterInsert()
    var
        UserRec: Record user;
    begin
        "Assigned User ID" := UserId;
        userrec.reset;
        userrec.setrange("User Name", Database.UserId);
        if UserRec.find('-') then
            "Requestor Name" := userrec."Full Name";
        PurchSetup.GET;
        PurchSetup.TESTFIELD("Requisition Default Vendor");

        IF DocApprovalType = (DocApprovalType::Requisition) THEN BEGIN
            "Buy-from Vendor No." := PurchSetup."Requisition Default Vendor";
            VALIDATE("Buy-from Vendor No.");
        END;
    end;

    procedure InsertRFQ(RFQHeader: Record "Purchase Quote Header")
    var
        RFQLines: Record "Purchase Quote Line";
        ReqLines: Record "Purchase Line";
        Ln: Integer;
    begin
        //RFQHeader.GET(RFQHeader."Document Type"::"Quotation Request","RFQ No.");

        ReqLines.Reset;
        ReqLines.SetRange(ReqLines."Document Type", "Document Type");
        ReqLines.SetRange(ReqLines."Document No.", "No.");
        ReqLines.DeleteAll;

        RFQLines.reset;
        RFQLines.SETRANGE(RFQLines."Document No.", RFQHeader."No.");
        if RFQLines.find('-') then begin
            repeat
                ln := ln + 1;
                ReqLines.Init;
                //ReqLines.TransferFields(RFQLines);
                ReqLines."Line No." := ReqLines."Line No." + ln;
                ReqLines."Document Type" := "Document Type";
                ReqLines."Document No." := "No.";
                ReqLines.Type := RFQLines.Type;
                ReqLines."No." := RFQLines."No.";
                ReqLines.Validate("No.");
                ReqLines.Description := RFQLines.Description;
                ReqLines.Quantity := RFQLines.Quantity;
                IF DocApprovalType = (DocApprovalType::Requisition) THEN BEGIN
                    ReqLines."Buy-from Vendor No." := PurchSetup."Requisition Default Vendor";

                END;
                //ReqLines."Buy-from Vendor No." := "Buy-from Vendor No.";
                ReqLines."Pay-to Vendor No." := "Pay-to Vendor No.";
                ReqLines."Requisition No" := RFQLines."Requisition No";
                ReqLines.Insert;

            until RFQLines.Next = 0;
            "RFQ No." := RFQHeader."No.";
            modify;
        end;

    end;

    var
        RFQ: Record "Purchase Quote Line";
        PurchLine: Record "Purchase Line";
        PurchSetup: Record "Purchases & Payables Setup";
        postship: record "Purch. Rcpt. Header";
        inspectionheader: Record "Inspection Header";

}
