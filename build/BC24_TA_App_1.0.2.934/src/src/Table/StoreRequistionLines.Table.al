Table 50907 "Store Requistion Lines"
{

    fields
    {
        field(1; "Requistion No"; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                  IF ReqHeader.GET("Requistion No") THEN BEGIN
                    IF ReqHeader."Global Dimension 1 Code"='' THEN
                       ERROR('Please Select the Global Dimension 1 Requisitioning')
                  END;
                 */

            end;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,Asset';
            OptionMembers = " ",Item,"Asset";
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(Item)) Item."No."
            else
            if (Type = const(Asset)) "Fixed Asset"."No." where("Original Location" = filter(''));

            trigger OnValidate()
            begin

                if ReqHeader.get("Requistion No") then begin
                    if "Issuing Store" = '' then
                        "Issuing Store" := ReqHeader."Issuing Store";
                end;
                //Control: Don't Post Same Item Twice NOT GL's
                if Type = Type::" " then begin
                    RequisitionLine.Reset;
                    RequisitionLine.SetRange(RequisitionLine."Requistion No", "Requistion No");
                    RequisitionLine.SetRange(RequisitionLine."No.", "No.");
                    if RequisitionLine.Find('-') then
                        Error('You Cannot enter two lines for the same Item');
                end;
                //

                "Action Type" := "action type"::"Ask for Quote";

                if Type = Type::Item then begin
                    if QtyStore.Get("No.") then
                        Description := QtyStore.Description;
                    "Unit of Measure" := QtyStore."Base Unit of Measure";
                    "Unit Cost" := QtyStore."Unit Cost";
                    "Line Amount" := "Unit Cost" * Quantity;
                    QtyStore.CalcFields(QtyStore.Inventory);
                    "Qty in store" := QtyStore.Inventory;
                    if ((QtyStore.Inventory <= 0)) then Message('There are no  ''' + QtyStore.Description + '''  on stock.');
                    //   IF ((QtyStore.Inventory<=0)) THEN ERROR('There are no '''+QtyStore.Description+''' in the Store to be issued!!\Please consult the store Manager for advice.');
                end;

                if Type = Type::Item then begin
                    if Item.Get("No.") then
                        Description := Item.Description;
                end;

                if Type = Type::Asset then begin
                    if FA.Get("No.") then
                        Description := FA.Description;
                end;


                /*
                {Modified}
                         //Validate Item
                      GLAccount.GET(QtyStore."Item G/L Budget Account");
                      GLAccount.CheckGLAcc;
                
                */

            end;
        }
        field(6; Description; Text[70])
        {
            Caption = 'Description';
        }
        field(7; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin


                if Type = Type::" " then begin
                    "Line Amount" := "Unit Cost" * Quantity;
                end;

                if QtyStore.Get("No.") then
                    QtyStore.CalcFields(QtyStore.Inventory);
                "Qty in store" := QtyStore.Inventory;
                //CheckStocklevel;
            end;
        }
        field(9; "Qty in store"; Decimal)
        {
            FieldClass = Normal;
        }
        field(10; "Request Status"; Option)
        {
            Editable = true;
            OptionMembers = Pending,Released,"Director Approval","Budget Approval","FD Approval","CEO Approval",Approved,Closed;
        }
        field(11; "Action Type"; Option)
        {
            OptionMembers = " ",Issue,"Ask for Quote";

            trigger OnValidate()
            begin
                if Type = Type::" " then begin
                    if "Action Type" = "action type"::Issue then
                        Error('You cannot Issue a G/L Account please order for it')
                end;


                //Compare Quantity in Store and Qty to Issue
                // if Type = Type::" " then begin
                if Type = Type::Item then
                    //if Type = Type::"Asset" then begin
                        if "Action Type" = "action type"::Issue then begin
                        if "Quantity Issued" > "Qty in store" then
                            Error('You cannot Issue More than what is available in store')
                    end;
            end;
        }
        field(12; "Unit of Measure"; Code[20])
        {
            TableRelation = "Unit of Measure";
        }
        field(13; "Total Budget"; Decimal) { }
        field(14; "Current Month Budget"; Decimal) { }
        field(15; "Unit Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                // IF Type=Type::Item THEN
                "Line Amount" := "Unit Cost" * Quantity;
            end;
        }
        field(16; "Line Amount"; Decimal) { }
        field(17; "Quantity Requested"; Decimal)
        {
            Caption = 'Quantity Requested';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                Quantity := "Quantity Requested";
                "Quantity To Issue" := Quantity;

                Validate(Quantity);
                "Line Amount" := "Unit Cost" * Quantity;
            end;
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(26; "Current Actuals Amount"; Decimal) { }
        field(27; Committed; Boolean) { }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(83; "Issuing Store"; Code[20])
        {
            TableRelation = if (Type = const(Item)) Location
            else
            if (Type = const(Asset)) "FA Location";
        }
        field(84; "Quantity To Issue"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                if "Quantity To Issue" > "Quantity Requested" then Error('You cannot Issue more than requested.');
                if ("Quantity Issued" + "Quantity To Issue") > "Quantity Requested" then
                    Error('Total Issued Items cannot exceed the Total Requested..');
                "Issue Quantity" := "Quantity To Issue";
                "Line Amount" := "Unit Cost" * "Quantity Issued";
            end;
        }
        field(85; "Quantity Issued"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(86; "Issue Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(89; "Quantity Received"; Integer)
        {

        }
        field(50035; "Budgeted Amount"; Decimal)
        {
            CalcFormula = sum("G/L Budget Entry".Amount where("Budget Name" = field("Budget Name"),
                                                               "G/L Account No." = field("Vote Account"),
                                                               "Global Dimension 1 Code" = field("Shortcut Dimension 1 Code"),
                                                               "Global Dimension 2 Code" = field("Shortcut Dimension 2 Code")));
            FieldClass = FlowField;
        }
        field(50036; "Actual Expenditure"; Decimal)
        {
            FieldClass = Normal;
        }
        field(50037; "Committed Amount"; Decimal)
        {
            CalcFormula = sum(Committment.Amount where("G/L Account No." = field("Vote Account"),
                                                        Budget = field("Budget Name"),
                                                        "Shortcut Dimension 1 Code" = field("Shortcut Dimension 1 Code"),
                                                        "Shortcut Dimension 2 Code" = field("Shortcut Dimension 2 Code")));
            FieldClass = FlowField;
        }
        field(50038; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(50039; "Budget Balance"; Decimal) { }
        field(50040; "Vote Account"; Code[20]) { }
        field(50041; "Posted Count"; Integer)
        {
            CalcFormula = count("Item Ledger Entry" where("Item No." = field("No."),
                                                           "Document No." = field("Requistion No")));
            FieldClass = FlowField;
        }
        field(50042; "Last Date of Issue"; date) { }
        field(50043; "Last Quantity Issued"; Decimal) { }
        field(50044; "Lot No."; code[20]) { }
        field(50045; "Remarks"; text[200]) { }
        field(50046; "Temp. Journal No."; Integer) { }
        field(50048; "Tag No"; Text[50])
        {
            Editable = false;
            
             trigger OnValidate()
            begin
                IF "Tag No" = '' THEN BEGIN
                    itemcat.Get;
                    itemcat.TestField("Number sequence");
                    NoSeriesMgt.TestManual(itemcat."Number sequence");
                    

                END;
            end;
        }


    }

    keys
    {
        key(Key1; "Requistion No", "No.")
        {
            Clustered = true;
            SumIndexFields = "Line Amount";
        }
        key(Key2; "No.", Type, "Request Status")
        {
            SumIndexFields = Quantity;
        }

    }

    fieldgroups { }

    trigger OnDelete()
    begin
        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."No.", "Requistion No");
        if ReqHeader.Find('-') then
            if ReqHeader.Status <> ReqHeader.Status::Open then
                Error('You Cannot Delete Entries if status is not Pending')
    end;

    trigger OnInsert()
    begin

        "Line Amount" := "Unit Cost" * Quantity;

        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."No.", "Requistion No");
        if ReqHeader.Find('-') then begin
            "Shortcut Dimension 1 Code" := ReqHeader."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := ReqHeader."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := ReqHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := ReqHeader."Shortcut Dimension 4 Code";
            // IF ReqHeader.Status<>ReqHeader.Status::Open THEN
            //     ERROR('You Cannot Enter Entries if status is not Pending')
        end;
    end;

    trigger OnModify()
    begin

        if Type = Type::" " then
            "Line Amount" := "Unit Cost" * Quantity;


        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."No.", "Requistion No");
        if ReqHeader.Find('-') then begin
            "Shortcut Dimension 1 Code" := ReqHeader."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := ReqHeader."Shortcut Dimension 2 Code";
            "Shortcut Dimension 3 Code" := ReqHeader."Shortcut Dimension 3 Code";
            "Shortcut Dimension 4 Code" := ReqHeader."Shortcut Dimension 4 Code";
            if ReqHeader.Status <> ReqHeader.Status::Open then
                if (("Quantity To Issue" = xRec."Quantity To Issue") and (xRec."Quantity Issued" = "Quantity Issued")
                and ("Issue Quantity" = xRec."Issue Quantity")) then
                    Error('You Cannot Modify Entries if status is not Pending')
        end;

        /* ReqHeader.RESET;
         ReqHeader.SETRANGE(ReqHeader."No.","Requistion No");
         IF ReqHeader.FIND('-') THEN BEGIN
          "Shortcut Dimension 1 Code":=ReqHeader."Global Dimension 1 Code";
          "Shortcut Dimension 2 Code":=ReqHeader."Shortcut Dimension 2 Code";
          "Shortcut Dimension 3 Code":=ReqHeader."Shortcut Dimension 3 Code";
          "Shortcut Dimension 4 Code":=ReqHeader."Shortcut Dimension 4 Code";
          IF ReqHeader.Status<>ReqHeader.Status::Open THEN
              ERROR('You Cannot Modify Entries if status is not Pending')
         END; */

    end;

    var
        QtyStore: Record Item;
        ReqHeader: Record "Store Requistion Header";
        RequisitionLine: Record "Store Requistion Lines";
        Item: Record Item;
        FA: Record "Fixed Asset";
        qty: Integer;
        itemcat: Record "Item Subcategory";
        NoSeriesMgt: Codeunit "No. Series";

    procedure CheckStocklevel()
    begin
        Item.Reset;
        Item.Get("No.");
        Item.SetFilter(Item."Location Filter", "Issuing Store");
        Item.CalcFields(Item.Inventory);
        qty := Item.Inventory;
        if (qty - Quantity) < 0 then begin
            Error('This transaction will result in Negative stock');
        end;
    end;
}

