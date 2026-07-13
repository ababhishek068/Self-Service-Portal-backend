Table 50451 "Approval Templates"
{
    Caption = 'Approval Templates';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = false;
        }
        field(2; "Approval Code"; Code[20])
        {
            Caption = 'Approval Code';
            TableRelation = "Approval Code".Code;

            trigger OnValidate()
            begin
                TestField(Enabled, false);
                ApprCode.Get("Approval Code");
                // ApprCode.TestField("Linked To Table No.");
                "Table ID" := ApprCode."Linked To Table No.";
            end;
        }
        field(3; "Approval Type"; Option)
        {
            Caption = 'Approval Type';
            OptionCaption = ' ,Sales Pers./Purchaser,Approver';
            OptionMembers = " ","Sales Pers./Purchaser",Approver;

            trigger OnValidate()
            begin
                TestField(Enabled, false);
            end;
        }
        field(4; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Payment Voucher,Petty Cash,Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,Import Permit,Export Permit,TR,Safari Notice,Student Applications,Water Research,Consultancy Requests,Consultancy Proposals,Meals Bookings,General Journal,Student Admissions,Staff Claim,KitchenStoreRequisition,Leave Application,PCA,StaffMovement,Medical Claims/General Claims,Tuition waiver,Leave Extension Requisition,Staff Update,Graduation,Campus Transfer,Programme Transfer,Additional Units,Defferal,StudyMode,ExamRemark,SpecialExam,Supplimentary,MassPCA,ExitReq';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application",PCA,StaffMovement,"Medical Claims/General Claims","Tuition waiver","Leave Extension Requisition","Staff Update",Graduation,"Campus Transfer","Programme Transfer","Additional Units",Defferal,StudyMode,ExamRemark,SpecialExam,Supplimentary,MassPCA,ExitReq;

            trigger OnValidate()
            begin
                TestField(Enabled, false);
            end;
        }
        field(5; "Limit Type"; Option)
        {
            Caption = 'Limit Type';
            OptionCaption = 'Approval Limits,Credit Limits,Request Limits,No Limits,Tiered';
            OptionMembers = "Approval Limits","Credit Limits","Request Limits","No Limits",Tiered;

            trigger OnValidate()
            begin
                TestField(Enabled, false);
            end;
        }
        field(6; "Additional Approvers"; Boolean)
        {
            CalcFormula = exist("Additional Approvers" where("Approval Code" = field("Approval Code"),
                                                              "Approval Type" = field("Approval Type"),
                                                              "Document Type" = field("Document Type"),
                                                              "Limit Type" = field("Limit Type"),
                                                              "Approver ID" = filter(<> '')));
            Caption = 'Additional Approvers';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; Enabled; Boolean)
        {
            Caption = 'Enabled';

            trigger OnValidate()
            var
                Salesheader: Record "Sales Header";
                PurchaseHeader: Record "Purchase Header";
                ApprovalEntry: Record "Approval Entry";
                TempApprovalTemplate: Record "Approval Templates";
            begin
                if (Enabled = false) and (xRec.Enabled = true) then begin
                    TempApprovalTemplate.SetRange("Approval Code", "Approval Code");
                    TempApprovalTemplate.SetRange("Document Type", "Document Type");
                    if not TempApprovalTemplate.FindFirst then
                        case "Table ID" of
                            Database::"Sales Header":
                                begin
                                    Salesheader.SetCurrentkey("Document Type", Status);
                                    Salesheader.SetRange("Document Type", "Document Type");
                                    Salesheader.SetRange(Status, Salesheader.Status::"Pending Approval");
                                    if Salesheader.FindFirst then begin
                                        if Confirm(Text006) then begin
                                            ApprovalEntry.SetRange("Table ID", Database::"Sales Header");
                                            ApprovalEntry.SetRange("Document Type", "Document Type");
                                            ApprovalEntry.SetFilter(
                                              Status, '%1|%2|%3', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved);
                                            if ApprovalEntry.FindFirst then
                                                ApprovalEntry.ModifyAll(Status, ApprovalEntry.Status::Canceled);
                                        end;
                                        Salesheader.ModifyAll(Status, Salesheader.Status::Open);
                                    end;
                                end;
                            Database::"Purchase Header":
                                begin
                                    PurchaseHeader.SetCurrentkey("Document Type", Status);
                                    PurchaseHeader.SetRange("Document Type", "Document Type");
                                    PurchaseHeader.SetRange(Status, PurchaseHeader.Status::"Pending Approval");
                                    if PurchaseHeader.FindFirst then begin
                                        if Confirm(Text006) then begin
                                            ApprovalEntry.SetRange("Table ID", Database::"Purchase Header");
                                            ApprovalEntry.SetRange("Document Type", "Document Type");
                                            ApprovalEntry.SetFilter(
                                              Status, '%1|%2|%3', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved);
                                            if ApprovalEntry.FindFirst then
                                                ApprovalEntry.ModifyAll(Status, ApprovalEntry.Status::Canceled);
                                        end;
                                        PurchaseHeader.ModifyAll(Status, Salesheader.Status::Open);
                                    end;
                                end;
                        end;
                end;

                if "Approval Type" = "approval type"::" " then begin
                    CalcFields("Additional Approvers");
                    if not "Additional Approvers" and Enabled then
                        Error(StrSubstNo(Text005, FieldCaption("Approval Type")));
                end;
                if ("Approval Type" <> "approval type"::" ") and ("Limit Type" = "limit type"::"Credit Limits") then begin
                    CalcFields("Additional Approvers");
                    if not "Additional Approvers" and Enabled then
                        Error(StrSubstNo(Text007, FieldCaption("Approval Type"), Format("Approval Type"),
                            FieldCaption("Limit Type")));
                end;
            end;
        }
        field(50000; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
    }

    keys
    {
        key(Key1; "Approval Code", "Approval Type", "Document Type", "Limit Type")
        {
            Clustered = true;
        }
        key(Key2; "Table ID", "Approval Type", Enabled) { }
        key(Key3; "Approval Code", "Approval Type", Enabled) { }
        key(Key4; Enabled) { }
        key(Key5; "Limit Type", "Document Type", "Approval Type", Enabled) { }
        key(Key6; "Table ID", "Document Type", Enabled) { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        AdditionalApprovers.SetRange("Approval Code", "Approval Code");
        AdditionalApprovers.SetRange("Approval Type", "Approval Type");
        AdditionalApprovers.SetRange("Document Type", "Document Type");
        AdditionalApprovers.SetRange("Limit Type", "Limit Type");
        AdditionalApprovers.DeleteAll;
    end;

    trigger OnInsert()
    begin
        TestValidation;
    end;

    trigger OnRename()
    begin
        TestValidation;
        RenameAddApprovers(Rec, xRec);
    end;

    var
        ApprCode: Record "Approval Code";
        AdditionalApprovers: Record "Additional Approvers";
        Text001: label '%1 is not a valid limit type for table %2.';
        Text002: label '%1 is only valid for table %2.';
        Text004: label '%1 is only valid when document type is Quote and Table ID is %2.';
        Text005: label 'Additional Approvers must be inserted if %1 is blank.';
        Text006: label 'Do you want to cancel all outstanding approvals? ';
        Text007: label 'Additional Approvers must be inserted if %1 is %2 and %3 is Credit Limit.';

    procedure TestValidation()
    var
        AppSetup: Record "Approval Setup";
    begin
        AppSetup.Get;
        if ("Table ID" = Database::"Purchase Header") and
           ("Limit Type" = "limit type"::"Credit Limits")
        then
            Error(StrSubstNo(Text001, Format("Limit Type"), Database::"Purchase Header"));

        if ("Table ID" <> Database::"Purchase Header") and
           ("Limit Type" = "limit type"::"Request Limits")
        then
            Error(StrSubstNo(Text002, Format("Limit Type"), Database::"Purchase Header"));

        if ("Table ID" = Database::"Purchase Header") and
           ("Limit Type" = "limit type"::"Request Limits") and
           ("Document Type" <> "document type"::Quote)
        then
            Error(StrSubstNo(Text004, Format("Limit Type"), "Table ID"));
    end;

    procedure RenameAddApprovers(Template: Record "Approval Templates"; xTemplate: Record "Approval Templates")
    var
        AddApprovers: Record "Additional Approvers";
        RenamedAddApprovers: Record "Additional Approvers";
    begin
        AddApprovers.SetRange("Approval Code", xTemplate."Approval Code");
        AddApprovers.SetRange("Approval Type", xTemplate."Approval Type");
        AddApprovers.SetRange("Document Type", xTemplate."Document Type");
        AddApprovers.SetRange("Limit Type", xTemplate."Limit Type");
        if AddApprovers.Find('-') then
            repeat
                RenamedAddApprovers := AddApprovers;
                RenamedAddApprovers."Approval Code" := Template."Approval Code";
                RenamedAddApprovers."Approval Type" := Template."Approval Type";
                RenamedAddApprovers."Document Type" := Template."Document Type";
                RenamedAddApprovers."Limit Type" := Template."Limit Type";
                AddApprovers.Delete;
                RenamedAddApprovers.Insert;
            until AddApprovers.Next = 0;
    end;
}

