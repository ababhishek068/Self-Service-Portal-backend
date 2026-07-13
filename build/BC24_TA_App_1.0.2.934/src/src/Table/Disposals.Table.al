Table 50727 "Disposals"
{

    fields
    {
        field(1; "Disposal No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Disposal Period"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Disposal Period".Code;
            trigger OnValidate()
            var
                DispLines: Record "Disposal Plan Lines";
                PlanLines: Record "Disposal plan table lines";
                PlanHeader: Record "Disposal Plan Table Header";
            begin
                PlanHeader.reset;
                PlanHeader.setrange("Disposal Year", "Disposal Period");
                PlanHeader.setrange(PlanHeader.Status, PlanHeader.Status::Approved);
                if PlanHeader.find('-') then begin
                    repeat
                        PlanLines.reset;
                        PlanLines.setrange(PlanLines."Ref. No.", PlanHeader."No.");
                        if PlanLines.find('-') then begin
                            repeat
                                DispLines.init;
                                DispLines."Disposal  No" := "Disposal No.";
                                DispLines."No." := PlanLines."No.";
                                DispLines.Description := PlanLines."Item description";
                                DispLines."Serial No" := PlanLines."Serial No";
                                DispLines."Line No." := PlanLines."Line No.";
                                DispLines."Justification For Disposal" := PlanLines.Justification;
                                DispLines."Shortcut Dimension 1 Code" := PlanLines.Department;
                                DispLines."Fixed Location" := PlanLines."Asset Location";
                                DispLines."Tag No." := PlanLines."Item/Tag No";

                                DispLines.insert;
                            until PlanLines.next = 0;
                        end;
                    until PlanHeader.next = 0;
                end
            end;
        }
        field(3; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Planned Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Approved,Pending Approval,Cancelled,Recected';
            OptionMembers = Open,Approved,"Pending Approval",Cancelled,Recected;
        }
        field(7; "Disposal Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Approved,Pending Approval,Cancelled,Recected';
            OptionMembers = Open,Approved,"Pending Approval",Cancelled,Recected;
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
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
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
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
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin

                TestField(Status, Status::Open);

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
        field(20; "Prepared By"; Code[20])
        {
            Caption = 'Prepared By';
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
        if "Disposal No." = '' then begin
            GenLedgerSetup.Get();
            GenLedgerSetup.TestField(GenLedgerSetup."Disposal No.");
            "Disposal No.":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Disposal No.", 0D, true);
        end;
    end;

    var
        GenLedgerSetup: Record "Purchases & Payables Setup";

        //UserDept: Record UnknownRecord70134871; //Imprest Surrender Details

        //RespCenter: Record UnknownRecord70134898; //Responsibility Center BR
        Dimval: Record "Dimension Value";
        NoSeriesMgt: Codeunit "No. Series";
}

