pageextension 50048 "Approval Entry Ext" extends "Approval Entries"
{
    layout
    {
        addbefore(Details)
        {
            field("Document No.1"; Rec."Document No.")
            {

                ApplicationArea = basic;
                ToolTip = 'Specifies the document number copied from the relevant sales or purchase document, such as a purchase order or a sales quote.';
            }
            field(Description; Rec.Description)
            {
                Caption = 'Description';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Description field.';
            }
            field("Sender Name"; Rec."Sender Name")
            {
                Caption = 'Sender Name';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Sender Name field.';
            }
            field("Approval Name"; Rec."Approval Name")
            {
                Caption = 'Approver Name';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Approver Name field.';
            }


        }
    }
    actions
    {

        addafter("O&verdue Entries")
        {
            action(UpdateDesc)
            {
                ApplicationArea = basic;
                caption = 'Update Description';
                image = UpdateDescription;
                ToolTip = 'Executes the Update Description action.';
                trigger OnAction()
                var
                    UpdateAppEntry: Report "Update Approval Entry";
                begin
                    UpdateAppEntry.Run();
                end;

            }
        }

    }
    trigger OnAfterGetRecord()
    var
        AppEntry: Record "Approval Entry";
    begin
        /* if PayHeader.get("Document No.") then Desc := PayHeader.Payee;
        if ImpHeader.get("Document No.") then Desc := ImpHeader.Payee;
        if StudApp.get("Document No.") then Desc := StudApp.Surname + ' ' + StudApp."Other Names";
        PurchHeader.reset;
        PurchHeader.setrange("No.", "Document No.");
        if PurchHeader.find('-') then Desc := PurchHeader."Buy-from Vendor Name"; */
        /*  HREmp.Reset();
         HREmp.SetRange("User ID", "Sender ID");
         if HREmp.Find('-') then Sendername := HREmp."First Name" + ' ' + HRemp."Last Name";

         HREmp.Reset();
         HREmp.SetRange("User ID", "Approver ID");
         if HREmp.Find('-') then Approvername := HREmp."First Name" + ' ' + HRemp."Last Name"; */

        HrSetup.Get();
        if HrSetup."Webservice Account" <> '' then begin
            AppEntry.reset;
            AppEntry.SetRange("Sender ID", HrSetup."Webservice Account");
            // AppEntry.SetRange(Updated, false);
            if AppEntry.find('-') then begin
                repeat
                    // AppEntry.Description='';
                    if PayHeader.get(AppEntry."Document No.") then begin
                        AppEntry.Description := PayHeader.Payee;
                        if HR.get(PayHeader."Employee No") then
                            if HR."User ID" <> '' then
                                AppEntry."Sender ID" := HR."User ID";
                        AppEntry."Sender Name" := HR."First Name" + ' ' + HR."Last Name";
                    end;
                    if ImpHeader.get(Rec."Document No.") then begin
                        AppEntry.Description := ImpHeader.Purpose;
                        if HR.get(ImpHeader."Employee No.") then
                            if HR."User ID" <> '' then
                                AppEntry."Sender ID" := HR."User ID";
                        AppEntry."Sender Name" := HR."First Name" + ' ' + HR."Last Name";
                    end;
                    if ClaimHeader.get(Rec."Document No.") then begin
                        AppEntry.Description := ClaimHeader.Purpose;
                        if HR.get(ClaimHeader."Employee No") then
                            if HR."User ID" <> '' then
                                AppEntry."Sender ID" := HR."User ID";
                        AppEntry."Sender Name" := HR."First Name" + ' ' + HR."Last Name";
                    end;
                    // if StudApp.get(AppEntry."Document No.") then AppEntry.Description := StudApp.Surname + ' ' + StudApp."Other Names";
                    if StoreRec.get(AppEntry."Document No.") then begin
                        AppEntry.Description := StoreRec."Request Description";
                        if HR.get(StoreRec."Employee No") then
                            if HR."User ID" <> '' then
                                AppEntry."Sender ID" := HR."User ID";
                        AppEntry."Sender Name" := HR."First Name" + ' ' + HR."Last Name";
                    end;
                    PurchHeader.reset();
                    PurchHeader.setrange("No.", AppEntry."Document No.");
                    if PurchHeader.find('-') then begin
                        AppEntry.Description := PurchHeader."Buy-from Vendor Name";
                        if HR.get(PurchHeader."Employee No.") then
                            if HR."User ID" <> '' then
                                AppEntry."Sender ID" := HR."User ID";
                        AppEntry."Sender Name" := HR."First Name" + ' ' + HR."Last Name";
                    end;
                    // AppEntry.Updated := true;
                    HREmp.Reset();
                    HREmp.SetRange("User ID", AppEntry."Approver ID");
                    if HREmp.Find('-') then AppEntry."Approval Name" := HREmp."First Name" + ' ' + HRemp."Last Name";
                    AppEntry.modify;
                until AppEntry.next = 0;
            end;

        end;

    end;

    trigger OnAfterGetCurrRecord()
    begin
        /* if PayHeader.get("Document No.") then Desc := PayHeader.Payee;
        if ImpHeader.get("Document No.") then Desc := ImpHeader.Payee;
        if StudApp.get("Document No.") then Desc := StudApp.Surname + ' ' + StudApp."Other Names";
        PurchHeader.reset;
        PurchHeader.setrange("No.", "Document No.");
        if PurchHeader.find('-') then Desc := PurchHeader."Buy-from Vendor Name"; */
        //if HREmp.get("Sender ID") then Sendername := HREmp."First Name" + ' ' + HRemp."Last Name";
        //if HREmp.get("Approver ID") then Approvername := HREmp."First Name" + ' ' + HRemp."Last Name";
    end;

    trigger OnOpenPage()
    var
        AppEntry: Record "Approval Entry";
    begin
        HrSetup.Get();
        if HrSetup."Webservice Account" <> '' then begin
            AppEntry.reset;
            AppEntry.SetRange("Sender ID", HrSetup."Webservice Account");
            //AppEntry.SetRange(Updated, false);
            if AppEntry.find('-') then begin
                repeat
                    // AppEntry.Description='';
                    if PayHeader.get(AppEntry."Document No.") then begin
                        AppEntry.Description := PayHeader.Payee;
                        if HR.get(PayHeader."Employee No") then
                            if HR."User ID" <> '' then
                                AppEntry."Sender ID" := HR."User ID";
                        AppEntry."Sender Name" := HR."First Name" + ' ' + HR."Last Name";
                    end;
                    if ImpHeader.get(Rec."Document No.") then begin
                        AppEntry.Description := ImpHeader.Purpose;
                        if HR.get(ImpHeader."Employee No.") then
                            if HR."User ID" <> '' then
                                AppEntry."Sender ID" := HR."User ID";
                        AppEntry."Sender Name" := HR."First Name" + ' ' + HR."Last Name";
                    end;
                    if ClaimHeader.get(Rec."Document No.") then begin
                        AppEntry.Description := ClaimHeader.Purpose;
                        if HR.get(ClaimHeader."Employee No") then
                            if HR."User ID" <> '' then
                                AppEntry."Sender ID" := HR."User ID";
                        AppEntry."Sender Name" := HR."First Name" + ' ' + HR."Last Name";
                    end;
                    // if StudApp.get(AppEntry."Document No.") then AppEntry.Description := StudApp.Surname + ' ' + StudApp."Other Names";
                    if StoreRec.get(AppEntry."Document No.") then begin
                        AppEntry.Description := StoreRec."Request Description";
                        if HR.get(StoreRec."Employee No") then
                            if HR."User ID" <> '' then
                                AppEntry."Sender ID" := HR."User ID";
                        AppEntry."Sender Name" := HR."First Name" + ' ' + HR."Last Name";
                    end;
                    PurchHeader.reset;
                    PurchHeader.setrange("No.", AppEntry."Document No.");
                    if PurchHeader.find('-') then begin
                        AppEntry.Description := PurchHeader."Buy-from Vendor Name";
                        if HR.get(PurchHeader."Employee No.") then
                            if HR."User ID" <> '' then
                                AppEntry."Sender ID" := HR."User ID";
                        AppEntry."Sender Name" := HR."First Name" + ' ' + HR."Last Name";
                    end;
                    // AppEntry.Updated := true;
                    HREmp.Reset();
                    HREmp.SetRange("User ID", AppEntry."Approver ID");
                    if HREmp.Find('-') then AppEntry."Approval Name" := HREmp."First Name" + ' ' + HRemp."Last Name";
                    AppEntry.modify;
                until AppEntry.next = 0;
            end;

        end;
    end;

    var
        HREmp: Record "HR-Employee";
        PayHeader: Record "Payments Header";
        ImpHeader: Record "Imprest Header";
        ClaimHeader: Record "Staff Claims Header";
        PurchHeader: Record "Purchase Header";
        HR: Record "HR-Employee";
        HrSetup: Record "HR Setup";

        StoreRec: Record "Store Requistion Header";
}