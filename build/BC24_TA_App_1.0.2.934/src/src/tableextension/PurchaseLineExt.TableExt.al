TableExtension 50006 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {

        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account"),
                                     "System-Created Entry" = CONST(false)) "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                                                               "Account Type" = CONST(Posting),
                                                                                               Blocked = CONST(false), "Expense Code" = field("Expense Code"))
            ELSE
            IF (Type = CONST("G/L Account"),
                                                                                                        "System-Created Entry" = CONST(true)) "G/L Account"
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
            ELSE
            IF (Type = CONST(Item),
            "Document Type" = FILTER(<> "Credit Memo" & <> "Return Order")) Item WHERE(Blocked = CONST(false),
                                                                                                                                                                                       "Purchasing Blocked" = CONST(false))
            ELSE
            IF (Type = CONST(Item),
                                                                                                                                                                                                "Document Type" = FILTER("Credit Memo" | "Return Order")) Item WHERE(Blocked = CONST(false))
            else
            if (Type = const(Resource)) Resource;


            trigger OnAfterValidate()
            var
                Item: Record item;
                BudgetControl: Record "Budgetary Control Setup";
            begin

                IF Type = Type::Item THEN BEGIN
                    IF Item.GET("No.") THEN BEGIN
                        Item.CALCFIELDS(Item.Inventory);
                        "Qty In Store" := Item.Inventory;
                        if BudgetControl.get() then
                            if (BudgetControl.Mandatory = true) and (BudgetControl."Check Budget On" = BudgetControl."Check Budget On"::Requisition) then
                                item.TestField("Item G/L Budget Account");
                        "G/L Account" := Item."Item G/L Budget Account";
                        /*
                          invPostSetup.RESET;
                          invPostSetup.SETRANGE(invPostSetup."Invt. Posting Group Code", Item."Inventory Posting Group");
                          invPostSetup.SETRANGE(invPostSetup."Location Code", "Location Code");
                          IF invPostSetup.FIND('-') THEN
                              "G/L Account" := invPostSetup."Inventory Account";
                              */
                    END;
                END ELSE
                    IF Type = Type::"Fixed Asset" THEN BEGIN
                        if FA.get("No.") then begin
                            IF FAPostSetup.GET(FA."FA Posting Group") THEN
                                "G/L Account" := FAPostSetup."Acquisition Cost Account";
                        end;
                    END ELSE
                        IF Type = Type::"G/L Account" THEN BEGIN
                            "G/L Account" := "No.";

                        END;
                //End Budget

                //----------

                BudgetAmount := 0;

                BCSetup.RESET;
                BCSetup.GET();
                IF BCSetup.Mandatory THEN//budgetary control is mandatory
                  BEGIN
                    BudgetAmount := 0;
                    Budget.RESET;
                    Budget.SETRANGE(Budget."Budget Name", BCSetup."Current Budget Code");
                    Budget.SETFILTER(Budget.Date, '%1..%2', BCSetup."Current Budget Start Date", BCSetup."Current Budget End Date");
                    Budget.SETRANGE(Budget."G/L Account No.", "G/L Account");
                    Budget.SETRANGE(Budget."Global Dimension 1 Code", "Shortcut Dimension 1 Code");
                    // IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::"2" THEN
                    Budget.SETRANGE(Budget."Global Dimension 2 Code", "Shortcut Dimension 2 Code");
                    IF Budget.FIND('-') THEN BEGIN
                        REPEAT
                            BudgetAmount := BudgetAmount + Budget.Amount;
                        UNTIL Budget.NEXT = 0;
                    END;
                END;

                "Budgeted Amount" := BudgetAmount;

                //Committment
                CommitmentAmount := 0;
                Commitments.RESET;
                Commitments.SETCURRENTKEY(Commitments.Budget, Commitments."G/L Account No.",
                Commitments."Posting Date", Commitments."Shortcut Dimension 1 Code", Commitments."Shortcut Dimension 2 Code");
                Commitments.SETRANGE(Commitments.Budget, BCSetup."Current Budget Code");
                Commitments.SETRANGE(Commitments."G/L Account No.", BudgetGL);
                Commitments.SETRANGE(Commitments."Posting Date", BCSetup."Current Budget Start Date", LastDay);
                Commitments.SETRANGE(Commitments."Shortcut Dimension 1 Code", Purchline."Shortcut Dimension 1 Code");
                //                    IF PurchHeader."Purchase Type"<>PurchHeader."Purchase Type"::"2" THEN
                Commitments.SETRANGE(Commitments."Shortcut Dimension 2 Code", Purchline."Shortcut Dimension 2 Code");
                IF Commitments.FIND('-') THEN BEGIN
                    Commitments.CALCSUMS(Commitments.Amount);
                    CommitmentAmount := Commitments.Amount;
                END;

                "Committed Amount" := CommitmentAmount;

            end;
        }


        modify("FA Posting Type")
        {
            OptionCaption = ' ,Acquisition Cost,Maintenance';

            //Unsupported feature: Property Modification (OptionString) on ""FA Posting Type"(Field 5601)".

        }
        modify(Nonstock)
        {
            Caption = 'Nonstock';
        }
        
        field(50000; Committed; Boolean)
        {
            Editable = true;
        }
        field(50001; "Vote Book"; Code[10]) { }
        // field(50004; "Expense Code"; Code[10])
        // {
        //     TableRelation = "Expense Code".code;
        // }

        //felix
        field(50600; "Expense Code"; Code[10])
        {
            TableRelation = "Expense Code".code;
        }
        field(50005; "RFQ No."; Code[20])

        {
            Description = 'ADDED THIS FIELD';
        }
        field(50006; "RFQ Line No."; Integer)
        {
            Description = 'ADDED THIS FIELD';
            // TableRelation = "Student Charges".Code;
        }
        field(50007; Select; Boolean) { }
        field(50008; "RFQ Created"; Boolean) { }

        field(50010; "Project Code"; Code[10])
        {
            // CalcFormula = lookup ("Purchase Header"."Budget Name" where("No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50011; Status; Option)
        {
            CalcFormula = lookup("Purchase Header".Status where("No." = field("Document No."),
                                                                 "Document Type" = field("Document Type")));
            Caption = 'Status';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(50012; "Asset No."; Code[10])
        {
            TableRelation = "Fixed Asset"."No.";
        }
        field(50013; "Document Type 2"; Option)
        {
            OptionMembers = Requisition,Quote,"Order";
        }
        field(50014; "Procurement Plan Item No"; Code[20])
        {
            TableRelation = "Procurement Plan Lines"."Type No" where(Department = field("Shortcut Dimension 2 Code"));

            trigger OnValidate()
            begin
                TestField("Shortcut Dimension 2 Code");
                PrPlan.Reset;
                PrPlan.SetRange(PrPlan.Department, "Shortcut Dimension 2 Code");
                PrPlan.SetRange(PrPlan."Type No", "Procurement Plan Item No");
                if PrPlan.Find('-') then begin
                    if Quantity > PrPlan."Remaining Qty" then Error('The selected items is more than items on procurement plan');
                    PrPlan."Remaining Qty" := PrPlan."Remaining Qty" - Quantity;
                    "Qty In Proc. Plan" := PrPlan."Remaining Qty" - Quantity;
                    PrPlan.Modify;
                end;
            end;
        }
        field(50033; "Request for Quote No."; Code[20])
        {
            // CalcFormula = lookup ("Purchase Header"."Budget Name" where("Document Type" = field("Document Type"),
            //                                                             "No." = field("Document No.")));
            FieldClass = FlowField;
            TableRelation = "Purchase Quote Header"."No.";

            trigger OnValidate()
            begin
                /*   //CHECK WHETHER HAS LINES AND DELETE
                 IF NOT CONFIRM('If you change the Request for Quote No. the current lines will be deleted. Do you want to continue?',FALSE)
                 THEN
                     ERROR('You have selected to abort the process') ;

                     PurchLine.RESET;
                     PurchLine.SETRANGE(PurchLine."Document No.","No.");
                     PurchLine.DELETEALL;

                 RFQ.RESET;
                 RFQ.SETRANGE(RFQ."Document No.","Request for Quote No.");
                 IF RFQ.FIND('-') THEN BEGIN
                   REPEAT
                       PurchLine.INIT;
                       PurchLine."Document Type":="Document Type";
                       PurchLine."Document No.":="No.";
                       PurchLine."Line No.":=RFQ."Line No.";
                       PurchLine.Type:=RFQ.Type;
                       PurchLine."Document Type 2":="Document Type 2";
                       PurchLine."No.":=RFQ."No.";
                       PurchLine.VALIDATE("No.");
                       PurchLine."Location Code":=RFQ."Location Code";
                       PurchLine.VALIDATE("Location Code");
                       PurchLine.Quantity:=RFQ.Quantity;
                       PurchLine.VALIDATE(Quantity);
                       PurchLine."Direct Unit Cost":=RFQ."Direct Unit Cost";
                       PurchLine.VALIDATE("Direct Unit Cost");
                       PurchLine.Amount:=RFQ.Amount;
                       PurchLine.INSERT;
                   UNTIL RFQ.NEXT=0;
                 END;
                */

            end;
        }
        field(50034; "Line Created"; Boolean) { }
        field(50035; "Budgeted Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(50036; "Actual Expenditure"; Decimal)
        {
            CalcFormula = sum("G/L Entry".Amount where("G/L Account No." = field("G/L Account"),
                                                        "Global Dimension 1 Code" = field("Shortcut Dimension 1 Code"),
                                                        "Global Dimension 2 Code" = field("Shortcut Dimension 2 Code")));
            FieldClass = FlowField;
        }
        field(50037; "Committed Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(50038; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(50039; "Budget Balance"; Decimal) { }
        field(50040; "Description 3"; Text[150])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Description 2")));
            FieldClass = FlowField;
        }
        field(51000; "RFQ Remarks"; Text[50]) { }
        field(50796; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";


        }
        field(50797; "Shipping Agent Service Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));
        }
        field(51002; "Requisition No"; Code[20]) { }
        field(51003; "Expiry Date"; Date) { }
        field(51004; "Manually Added"; Boolean) { }
        field(70134983; "Procurement Type Code"; Code[20])
        {
            // TableRelation = "prEmployee Trans PCA";
        }
        field(70135338; "Manual Requisition No"; Code[20])
        {
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Quote),
                                                           Status = const(Released));

            trigger OnValidate()
            begin
                "Manually Added" := true;
            end;
        }
        field(99000760; "PO Number Track"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000761; "G/L Account"; Code[20])
        {
            FieldClass = Normal;
        }
        field(52000; "Request Summary"; text[250])
        {
            FieldClass = Normal;
        }
        field(52001; "WorkPlan No."; code[20])
        {
            TableRelation = "Workplan Activities"."Activity Code" where("Global Dimension 1 Code" = field("Shortcut Dimension 1 Code"), "Global Dimension 2 Code" = field("Shortcut Dimension 2 Code"));
            FieldClass = Normal;
            trigger onValidate()
            var
                WorkPlanactivity: record "Workplan Activities";
            begin
                WorkPlanactivity.reset;
                WorkPlanactivity.setrange("Activity Code", "WorkPlan No.");
                if WorkPlanactivity.find('-') then begin
                    if WorkPlanactivity."Qty Used" + Quantity > WorkPlanactivity.Quantity then
                        error('Please note that the selected item has been fully used');
                    "Expected Receipt Date" := WorkPlanactivity."Activity End  Date";
                    "Qty In Proc. Plan" := WorkPlanactivity."Approved Quantity";
                end;
            end;
        }
        field(52002; "Qty In Store"; Decimal)
        {
            FieldClass = Normal;
        }
        field(52003; "Qty In Proc. Plan"; Decimal)
        {
            FieldClass = Normal;
        }
        field(52004; "Board Member No"; code[20])
        {
            FieldClass = Normal;
            TableRelation = Vendor."No.";
        }
        field(52005; Cancelled; Boolean)
        {
            FieldClass = Normal;
        }
        field(52006; "Item G/L Budget Account"; Code[20])
        {
            TableRelation = "G/L Account"."No." where("Budget Controlled" = const(true));
            trigger OnValidate()
            var
                PurchSet: Record "Purchases & Payables Setup";
                ObjItem: Record Item;

            begin
                if (Type <> Type::Item) Then Error('Type must be item!');
                if ("No." = '') then Error('Select the Item G/L Account');
                PurchSet.Get();
                if PurchSet."Item GL Budget" = false then Error('Item Gl Budget must be enabled in Purchases and payables setup');
                ObjItem.reset;
                ObjItem.setrange(ObjItem."No.", "No.");
                If ObjItem.Find('-') then begin
                    ObjItem."Item G/L Budget Account" := "Item G/L Budget Account";
                    ObjItem.Modify();
                end;




            end;
        }
        field(52007; "Extended Description"; text[250])
        {

        }

    }


    trigger OnBeforeInsert()
    var
        PurchSetup: record "Purchases & Payables Setup";
    begin
        PurchSetup.GET;
        PurchSetup.TESTFIELD("Requisition Default Vendor");
        IF "Document Type" = "Document Type"::Quote THEN BEGIN
            "Buy-from Vendor No." := PurchSetup."Requisition Default Vendor";
        END;
    end;

    var
        PrPlan: Record "Procurement Plan Lines";
        Purchline: Record "Purchase Line";
        FA: Record "Fixed Asset";
        FAPostSetup: Record "FA Posting Group";
        LastDay: Date;
        Budget: Record "G/L Budget Entry";
        BudgetAmount: Decimal;
        BCSetup: Record "Budgetary Control Setup";
        BudgetGL: Code[20];
        Commitments: Record Committment;
        CommitmentAmount: Decimal;
}

