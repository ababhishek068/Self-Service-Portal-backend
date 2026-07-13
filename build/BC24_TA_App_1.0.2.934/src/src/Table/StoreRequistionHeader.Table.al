Table 50575 "Store Requistion Header"
{
    DrillDownPageID = "Store Requisition";
    LookupPageID = "Store Requisition";

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = false;

            trigger OnValidate()
            begin
                if "No." = '' then begin
                    if "No." <> xRec."No." then begin
                        GenLedgerSetup.Get();
                        NoSeriesMgt.TestManual(GenLedgerSetup."Stores Requisition No");
                        "No." := '';
                    end;
                end;
            end;
        }
        field(2; "Request date"; Date) { }
        field(3; "Test Field"; Code[20]) { }

        field(5; "Required Date"; Date) { }
        field(6; "Requester ID"; Code[30])
        {
            Caption = 'Requester ID';
            Editable = false;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
            end;

            trigger OnValidate()
            begin
            end;
        }
        field(7; "Request Description"; Text[150]) { }
        field(9; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(10; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Released,Pending Prepayment,Cancelled,Posted';
            OptionMembers = Open,"Pending Approval",Released,"Pending Prepayment",Cancelled,Posted;
        }
        field(11; Supplier; Code[20])
        {
            TableRelation = Vendor;
        }
        field(12; "Action Type"; Option)
        {
            OptionMembers = " ","Ask for Tender","Ask for Quote";

            trigger OnValidate()
            begin
                /*
                IF Type=Type::"G/L Account" THEN BEGIN
                   IF "Action Type"="Action Type"::Issue THEN
                            ERROR('You cannot Issue a G/L Account please order for it')
                END;


               //Compare Quantity in Store and Qty to Issue
                IF Type=Type::Item THEN BEGIN
                   IF "Action Type"="Action Type"::Issue THEN BEGIN
                    IF Quantity>"Qty in store" THEN
                      ERROR('You cannot Issue More than what is available in store')
                   END;
                END;
                */

            end;
        }
        field(29; Justification; Text[250]) { }
        field(30; "User ID"; Code[30]) { }
        field(31; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                Dimval.Reset;
                Dimval.SetRange(Dimval."Global Dimension No.", 1);
                Dimval.SetRange(Dimval.Code, "Global Dimension 1 Code");
                if Dimval.Find('-') then
                    "Function Name" := Dimval.Name
            end;
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                Dimval.Reset;
                Dimval.SetRange(Dimval."Global Dimension No.", 2);
                Dimval.SetRange(Dimval.Code, "Shortcut Dimension 2 Code");
                if Dimval.Find('-') then
                    "Budget Center Name" := Dimval.Name
            end;
        }
        field(57; "Function Name"; Text[100])
        {
            Description = 'Stores the name of the function in the database';
        }
        field(58; "Budget Center Name"; Text[100])
        {
            Description = 'Stores the name of the budget center in the database';
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                Dimval.Reset;
                //Dimval.SETRANGE(Dimval."Global Dimension No.",3);
                Dimval.SetRange(Dimval.Code, "Shortcut Dimension 3 Code");
                if Dimval.Find('-') then
                    Dim3 := Dimval.Name
            end;
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));

            trigger OnValidate()
            begin
                Dimval.Reset;
                //Dimval.SETRANGE(Dimval."Global Dimension No.",4);
                Dimval.SetRange(Dimval.Code, "Shortcut Dimension 4 Code");
                if Dimval.Find('-') then
                    Dim4 := Dimval.Name
            end;
        }
        field(83; Dim3; Text[250]) { }
        field(84; Dim4; Text[250]) { }
        field(85; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin

                TestField(Status, Status::Open);
                // if not UserMgt.CheckRespCenter(1, "Responsibility Center") then
                //    Error(
                //       Text001,
                //      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
                /*
               "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
               IF "Location Code" = '' THEN BEGIN
                 IF InvtSetup.GET THEN
                   "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
               END ELSE BEGIN
                 IF Location.GET("Location Code") THEN;
                 "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
               END;

               UpdateShipToAddress;
                  */
                /*
             CreateDim(
               DATABASE::"Responsibility Center","Responsibility Center",
               DATABASE::Vendor,"Pay-to Vendor No.",
               DATABASE::"Salesperson/Purchaser","Purchaser Code",
               DATABASE::Campaign,"Campaign No.");

             IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
               RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
               "Assigned User ID" := '';
             END;
               */

            end;
        }
        field(86; TotalAmount; Decimal)
        {
            CalcFormula = sum("Store Requistion Lines"."Line Amount" where("Requistion No" = field("No.")));
            FieldClass = FlowField;
        }
        field(87; "Issuing Store"; Code[10])
        {
            TableRelation = if ("Store Requisition Type" = const(Item)) Location
            else
            if ("Store Requisition Type" = const("Minor Asset")) "FA Location";

            trigger OnValidate()
            begin

                ReqLines.Reset;
                ReqLines.SetRange(ReqLines."Requistion No", "No.");
                if ReqLines.Find('-') then begin
                    repeat
                        ReqLines."Issuing Store" := "Issuing Store";
                    until ReqLines.Next = 0;
                end;
            end;
        }
        field(88; "Store Requisition Type"; Option)
        {
            OptionCaption = 'Item,Minor Asset';
            OptionMembers = Item,"Minor Asset";
        }
        field(89; "Issue Date"; Date) { }

        field(90; Committed; Boolean) { }
        field(91; "SRN.No"; Code[20]) { }
        field(92;received;Boolean){
            Editable=false;
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
        field(50049; Amount; Decimal)
        {
            CalcFormula = sum("Store Requistion Lines"."Line Amount" where("Requistion No" = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050; "Requisition Type"; Option)
        {
            OptionCaption = 'Stationery,Others, Dry Goodsf,Grocery,Cereals,Beverages,Fuel, Beef,Meat Products,Eggs,Perishables,Hardware Materials,Building Materials,Drugs,Non-Pharmaceuticals,Teaching Materials,Minor Assets,Assets';
            OptionMembers = Stationery,Others," Dry Goods",Grocery,Cereals,Beverages,Fuel," Beef","Meat Products",Eggs,Perishables,"Hardware Materials","Building Materials",Drugs,"Non-Pharmaceuticals","Teaching Materials","Minor Assets",Assets;
        }
        field(50051; "Department Name"; Text[250])
        {
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = filter('DEPARTMENT'),
                                                               Code = field("Shortcut Dimension 2 Code")));
            FieldClass = FlowField;
        }
        field(50052; "Employee No"; Code[20]) { }
        field(50053; "Posted Count"; Integer)
        {
            CalcFormula = count("Item Ledger Entry" where("Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(50054; "Ignore Resp. Center"; Boolean) { }
        field(50055; "Is HOD"; Boolean) { }
        field(50056; "Is Project"; Boolean) { }
        field(50057; "Store Issue No";Code[10]){
            Editable=false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        if Status <> Status::Open then
            Error('You Cannot DELETE an already released Requisition')
    end;

    trigger OnInsert()
    begin

        if "No." = '' then begin
            GenLedgerSetup.Get();
            GenLedgerSetup.TestField(GenLedgerSetup."Stores Requisition No");
            "No.":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Stores Requisition No", 0D, true);
        end;

        "HR-EMP".Reset;
        "HR-EMP".SetRange("HR-EMP"."User ID", UserId);
        if "HR-EMP".Find('-') then
            "Employee No" := "HR-EMP"."No.";

        "Request date" := today;
        "Requester ID" := Database.UserId;
    end;

    trigger OnModify()
    begin
        if (Status <> Status::Open) and (Status <> Status::Released) then
            Error('You Cannot MODIFY a Pending Approval Requisition');

        ReqLines.Reset;
        ReqLines.SetRange(ReqLines."Requistion No", "No.");
        if ReqLines.Find('-') then begin
            repeat
                ReqLines."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                ReqLines."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                ReqLines."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
                ReqLines."Shortcut Dimension 4 Code" := "Shortcut Dimension 4 Code";
            until ReqLines.Next = 0;
        end;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Cash Office Setup";
        Dimval: Record "Dimension Value";
        ReqLines: Record "Store Requistion Lines";
        "HR-EMP": Record "HR-Employee";
}

