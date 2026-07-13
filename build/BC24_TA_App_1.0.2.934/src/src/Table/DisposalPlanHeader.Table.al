Table 50724 "Disposal Plan Header"
{
    fields
    {
        field(1; "Disposal No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Disposal Period"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Disposal Period".Code;

            trigger OnValidate()
            begin
                CLEAR(Description);
                DisposalPeriod.RESET();
                IF DisposalPeriod.GET("Disposal Period") THEN Description := DisposalPeriod.Description;
            end;
        }
        field(3; Description; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval,Cancelled,Rejected';
            OptionMembers = Open,Approved,"Pending Approval",Cancelled,Rejected;
        }
        field(7; "Disposal Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",HOD,"Head of Procurement","Disposal Committee","Accounting Officer","Cabinet Secretary";
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                Dimval.RESET;
                Dimval.SETRANGE(Dimval."Global Dimension No.", 1);
                Dimval.SETRANGE(Dimval.Code, "Global Dimension 1 Code");
                IF Dimval.FIND('-') THEN
                    "Function Name" := Dimval.Name
            end;
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                Dimval.RESET;
                Dimval.SETRANGE(Dimval."Global Dimension No.", 2);
                Dimval.SETRANGE(Dimval.Code, "Shortcut Dimension 2 Code");
                IF Dimval.FIND('-') THEN
                    "Budget Center Name" := Dimval.Name
            end;
        }
        field(11; "Function Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the function in the database';
        }
        field(12; "Budget Center Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the budget center in the database';
        }
        field(13; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                Dimval.RESET;
                //Dimval.SETRANGE(Dimval."Global Dimension No.",3);
                Dimval.SETRANGE(Dimval.Code, "Shortcut Dimension 3 Code");
                IF Dimval.FIND('-') THEN
                    Dim3 := Dimval.Name
            end;
        }
        field(14; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                Dimval.RESET;
                //Dimval.SETRANGE(Dimval."Global Dimension No.",4);
                Dimval.SETRANGE(Dimval.Code, "Shortcut Dimension 4 Code");
                IF Dimval.FIND('-') THEN
                    Dim4 := Dimval.Name
            end;
        }
        field(15; Dim3; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Dim4; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin

                TESTFIELD(Status, Status::Open);
                /* IF NOT UserMgt.CheckRespCenter(1, "Responsibility Center") THEN
                     ERROR(
                       Text001,
                       RespCenter.TABLECAPTION, UserMgt.GetPurchasesFilter);


              "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
              IF "Location Code" = '' THEN BEGIN
                IF InvtSetup.GET THEN
                  "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
              END ELSE BEGIN
                IF Location.GET("Location Code") THEN;
                "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
              END;

              UpdateShipToAddress;


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
        field(18; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(20; "Prepared By"; Code[20])
        {
            Caption = 'Prepared By';
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                IF HREmp.GET("Prepared By") THEN "Prepared By Name" := HREmp."Full Name";
            end;
        }
        field(21; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Disposed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Disposal Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Donate,Sale';
            OptionMembers = " ",Donate,Sale;
        }
        field(24; "Prepared By Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(25; Consolidated; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Disposal No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        IF "Disposal No." = '' THEN BEGIN
            GenLedgerSetup.GET();
            GenLedgerSetup.TESTFIELD(GenLedgerSetup."Disposal No.");
           "Disposal No.":= NoSeriesMgt.GetNextNo(GenLedgerSetup."Disposal No.",  0D, true);
        END;

        "Prepared By" := USERID();
        "Document Date" := Today;
        HREmp.RESET();
        HREmp.SETRANGE("User ID", "Prepared By");
        IF HREmp.FINDFIRST() THEN "Prepared By Name" := HREmp."Full Name";
    end;

    var
        GenLedgerSetup: Record "Purchases & Payables Setup";
        //UserMgt: Codeunit "User Setup Management BR";
        Dimval: Record "Dimension Value";
        HREmp: Record "HR-Employee";
        NoSeriesMgt: Codeunit "No. Series";
        DisposalPeriod: Record "Disposal Period";
}

