table 50840 "Contract Addendum"
{
    fields
    {
        field(1; "Contract Reference No"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(2; "Contract Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Fixed Rate Contract Service,Fixed Rate Temporary Labour,Rate Base Temporary Labour';
            OptionMembers = " ","Fixed Rate Contract Service","Fixed Rate Temporary Labour","Rate Base Temporary Labour";
        }
        field(3; "Contractor No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            begin
                IF vend.GET("Contractor No.") THEN
                    "Contractor Name" := UPPERCASE(vend.Name);
            end;
        }
        field(4; "Contractor Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Effective Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CLEAR("Expiry Date");
                "Expiry Date" := CALCDATE(Duration, "Effective Date");
            end;
        }
        field(6; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Contract Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
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
                /*IF NOT UserMgt.CheckRespCenter(1, "Responsibility Center") THEN
                    ERROR(
                      Text001,
                      RespCenter.TABLECAPTION, UserMgt.GetPurchasesFilter);}*/

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
        field(19; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Rejected,Pending Approval,Cancelled,Approved';
            OptionMembers = Open,Rejected,"Pending Approval",Cancelled,Approved;
        }
        field(20; "Requested By"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                /*
               "Request Description":='';

               "Request Description":='Requested by ' + "Requested By";
                  */

            end;
        }
        field(21; "Remarks Section"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Subject Matter"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Contract Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Active,Expired,Cancelled,Approved';
            OptionMembers = " ",Active,Expired,Cancelled,Approved;
        }
        field(24; "File Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Contract."Contract Reference No" where(Active = filter('Yes'));
        }
        field(26; Duration; DateFormula)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Effective Date");
                CLEAR("Expiry Date");


                "Expiry Date" := CALCDATE(Duration, "Effective Date");
            end;
        }
        field(27; Active; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Milestone Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Milestone Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Paid Milestone"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Unpaid Milestone"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Procurement WorkPlan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Workplan."Workplan Code." WHERE(Blocked = FILTER('No'));
        }
        field(33; "Worplan Activity"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Procurement WorkPlan" = FILTER('ADMIN')) "Workplan Activities"."Activity Code" WHERE("Account Type" = FILTER('Posting'))
            ELSE
            IF ("Procurement WorkPlan" = FILTER('ICT')) "Workplan Activities"."Activity Code" WHERE("Account Type" = FILTER('Posting'));
        }

    }

    keys
    {
        key(Key1; "Contract Reference No", "Contract No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "Contract Reference No" = '' then begin
            GenLedgerSetup.Get();
            GenLedgerSetup.TestField(GenLedgerSetup."Contract Addendum Nos");
            "Contract Reference No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Contract Addendum Nos", 0D, true);
        end;

        CurrentYear := Format(Date2dmy(Today, 3));


        // "Contract No." := CurrentYear + '/' + IncStr(CurrentYear) + "Contract Reference No";
    end;

    var

        NoSeriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Purchases & Payables Setup";

        Dimval: Record "Dimension Value";
        vend: Record Vendor;
        CurrentYear: Code[20];
}