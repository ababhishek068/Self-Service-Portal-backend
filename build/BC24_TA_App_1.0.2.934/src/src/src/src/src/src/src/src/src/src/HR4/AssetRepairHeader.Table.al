Table 50285 "Asset Repair Header"
{
    DrillDownPageID = "Asset Repair List";
    LookupPageID = "Asset Repair List";

    fields
    {
        field(1; "Request No."; Code[20])
        {
            Editable = true;
        }
        field(5; Description; Text[100]) { }
        field(10; "Requested By"; Code[30]) { }
        field(15; "Request Date"; Date) { }
        field(20; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(25; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(30; Status; Option)
        {
            OptionMembers = New,"Pending Approval",Approved,Rejected,Posted,Cancelled;
            editable = false;
        }
        field(40; Comments; Text[100]) { }
        field(45; "No. Series"; Code[10]) { }
        field(50; "Total Cost"; Decimal)
        {
            CalcFormula = sum("Asset Repair Lines".Cost where("Request No." = field("Request No.")));
            FieldClass = FlowField;
        }
        field(55; "Incident No."; Code[20])
        {
            TableRelation = "Asset Incident"."Incident No.";

            trigger OnValidate()
            begin

                AssetInciLines.Reset;
                AssetInciLines.SetRange(AssetInciLines."Incident No.", "Incident No.");
                if AssetInciLines.FindSet then begin

                    //Remove Existing Maintenance Lines
                    AssetRepReqLines.Reset;
                    AssetRepReqLines.SetRange(AssetRepReqLines."Request No.", "Request No.");
                    if AssetRepReqLines.FindSet then AssetRepReqLines.DeleteAll;

                    repeat
                        AssetRepReqLines.Reset;
                        AssetRepReqLines.Init;
                        AssetRepReqLines."Request No." := "Request No.";
                        AssetRepReqLines."Line No." := 0;
                        AssetRepReqLines."Asset No" := AssetInciLines."Fixed Asset No.";
                        AssetRepReqLines.Validate(AssetRepReqLines."Asset No");
                        AssetRepReqLines."Dimension 1 Code" := AssetInciLines."Dimension 1 Code";
                        AssetRepReqLines."Dimension 2 Code" := AssetInciLines."Dimension 2 Code";
                        AssetRepReqLines.Insert(true);
                    until AssetInciLines.Next = 0;

                end
                else
                    Error(Txt001, "Incident No.");
            end;
        }
        field(56; "Asset Type"; Option)
        {
            Editable = false;
            OptionMembers = " ",Vehicles,"Other Assets";

            trigger OnValidate()
            begin
                /*
                //DW: Preventing Changing Asset Type When Asset Lines exits
                fn_TestNoLinesExist(FIELDCAPTION("Asset Type"));
                */

            end;
        }
        field(57; "Document Date"; Date)
        {
            Editable = false;
        }
        field(58; "Total Assets"; Integer)
        {
            CalcFormula = count("Asset Repair Lines" where("Request No." = field("Request No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "FA Subclass"; Text[30]) { }
        field(50000; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR".code;
        }
        field(50002; "Asset to Repair"; Code[20])
        {

            trigger OnValidate()
            begin
                /*FA.RESET;
                FA.SETRANGE(FA."No.","Asset to Transfer");
                IF FA.FIND('-') THEN BEGIN
                  "Asset Description" := FA.Description;
                  "From Location" := FA."FA Location Code";
                  "From Responsible Employee" := FA."Responsible Employee";
                
                    VALIDATE("From Responsible Employee");
                END ELSE
                BEGIN
                  "Asset Description" := ' ';
                  "From Location" := ' ';
                  "From Responsible Employee" := ' ';
                    VALIDATE("From Responsible Employee");
                END;
                
                items.RESET;
                items.SETRANGE(items."No.","Asset to Transfer");
                IF items.FIND('-') THEN BEGIN
                   "Asset Description":=items.Description;
                   END ELSE
                   BEGIN
                     "Asset Description":='';
                     END;
                */

            end;
        }
        field(50003; Posted; Boolean)
        {
            Editable = true;
        }
    }

    keys
    {
        key(Key1; "Request No.", "Asset Type")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "Request No." = '' then begin
            FASetup.Get;
            FASetup.TestField("Repair Request Nos.");
            "Request No.":=NoSeriesMgt.GetNextNo(FASetup."Repair Request Nos.", 0D,true);
        end;

        "Requested By" := UserId;
        "Request Date" := Today;
        "Document Date" := Today;
        //"Global Dimension 1 Code":='HQ';
        //"Global Dimension 2 Code":='FIN_ADM';
    end;

    var
        FASetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit "No. Series";
        AssetInciLines: Record "Asset Incident Lines";
        Txt001: label 'There are no Asset Incident Lines for Incident No. %1';
        AssetRepReqLines: Record "Asset Repair Lines";
        AssetRepairLines: Record "Asset Repair Lines";
        CompanyVehicles: Record "FLT-Vehicle Header";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        DocNumber: Code[20];
        NoSeriesManagement: Codeunit "No. Series";
        FixedAsset: Record "Fixed Asset";

    local procedure fn_TestNoLinesExist(FieldCaption: Text)
    var
        AssetRepairLine: Record "Asset Repair Lines";
        Text005: label 'You cannot change [ %1 ] because the document still has one or more lines.';
    begin
        AssetRepairLine.SetRange(AssetRepairLine."Request No.", "Request No.");
        if not AssetRepairLine.IsEmpty then Error(Text005, FieldCaption);
    end;

    procedure FNPostAssetRepairs()
    begin
        AssetRepairLines.Reset;
        AssetRepairLines.SetRange(AssetRepairLines."Request No.", "Request No.");
        if AssetRepairLines.Find('-') then begin
            CompanyVehicles.Reset;
            //CompanyVehicles.SetRange(CompanyVehicles."Registration No.",AssetRepairLines."Registartion No");
            if CompanyVehicles.Find('-') then begin
                repeat
                    //  CompanyVehicles."Current Mileage":=AssetRepairLines."Next Service Mileage";
                    //  CompanyVehicles."Serviced by":=AssetRepairLines."Service Provider Name";
                    //CompanyVehicles."Next Service Date":=AssetRepairLines."Approximate Service Date";
                    CompanyVehicles.Modify;
                    if CompanyVehicles.Modify = true then begin
                        FnGeneratePurchaseRequisition();
                        Posted := true;
                        Modify;
                    end;
                until CompanyVehicles.Next = 0;
            end;
        end;
    end;

    local procedure FnGeneratePurchaseRequisition()
    begin
        PurchasesPayablesSetup.Get();
        ///**************Purchase Header******************

        PurchaseHeader.Init;
        PurchaseHeader."Document Type" := PurchaseHeader."document type"::Quote;
        PurchaseHeader.DocApprovalType := PurchaseHeader.Docapprovaltype::Requisition;
        PurchaseHeader."Document Date" := Today;
        DocNumber := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Requisition No", Today, true);
        PurchaseHeader."No." := DocNumber;
        PurchaseHeader."Order Date" := Today;
        PurchaseHeader."Posting Date" := Today;
        PurchaseHeader."Requested Receipt Date" := Today;
        PurchaseHeader."Requestor Name" := UserId;
        PurchaseHeader."Request Description" := Description;
        PurchaseHeader."Responsibility Center" := "Responsibility Center";
        PurchaseHeader."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
        PurchaseHeader."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
        PurchaseHeader.Insert;
        //****************Lines***************
        AssetRepairLines.Reset;
        AssetRepairLines.SetRange(AssetRepairLines."Request No.", "Request No.");
        if AssetRepairLines.Find('-') then begin
            repeat
                PurchaseLine.Init;
                PurchaseLine."Document Type" := PurchaseLine."document type"::Quote;
                PurchaseLine."Document No." := DocNumber;
                PurchaseLine."Line No." := PurchaseLine."Line No." + 1;
                PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                PurchaseLine."No." := '';
                PurchaseLine."Location Code" := 'HQ';
                PurchaseLine."Posting Group" := FixedAsset."FA Posting Group";
                PurchaseLine."FA Posting Date" := Today;
                PurchaseLine."FA Posting Type" := PurchaseLine."fa posting type"::Maintenance;
                PurchaseLine.Description := 'Services % Repairs of Vehicle';
                PurchaseLine."Description 2" := AssetRepairLines.Description;
                // PurchaseLine."Unit of Measure":=FixedAsset."Unit Of Measure";

                //END;

                PurchaseLine."Expense Code" := 'REPAIRS';
                PurchaseLine.Quantity := 1;
                PurchaseLine."Unit Cost" := AssetRepairLines.Cost;
                PurchaseLine."Direct Unit Cost" := AssetRepairLines.Cost;
                //IF PurchaseLine."No."<>'' THEN
                PurchaseLine.Insert(true);

            until AssetRepairLines.Next = 0;
        end;


        Message('Asset repairs posted and Purchase Requisition has been created successfully');
    end;
}

