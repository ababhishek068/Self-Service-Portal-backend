pageextension 50046 "Requests to Approve" extends "Requests to Approve"
{
    layout
    {
        addbefore(Details)
        {
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the document number copied from the relevant sales or purchase document, such as a purchase order or a sales quote.';
            }
            field("Document Type"; Rec."Document Type")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the type of document that an approval entry has been created for. Approval entries can be created for six different types of sales or purchase documents:';
            }
            field(Description; Rec.Description)
            {
                Caption = 'Description';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Description field.';
            }
            field(SenderName; SenderName)
            {
                Caption = 'Sender Name';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Sender Name field.';
            }
            field(ApproverName; ApproverName)
            {
                Caption = 'Approver Name';
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Approver Name field.';
            }

        }
        addbefore(CommentsFactBox)

        {
            part(OtherApprovers; "Approval Entries List")
            {
                Caption = 'Document Approvers';
                ApplicationArea = Suite;
                SubPageLink = "Document No." = field("Document No.");

            }
        }

    }
    actions
    {
        addafter(Reject)
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
    begin
        /* if PayHeader.get("Document No.") then Desc := PayHeader.Payee;
        if ImpHeader.get("Document No.") then Desc := ImpHeader.Payee;
        if StudApp.get("Document No.") then Desc := StudApp.Surname + ' ' + StudApp."Other Names";
        PurchHeader.reset;
        PurchHeader.setrange("No.", "Document No.");
        if PurchHeader.find('-') then Desc := PurchHeader."Buy-from Vendor Name"; */

        HREmp.Reset();
        HREmp.SetRange("User ID", Rec."Sender ID");
        if HREmp.Find('-') then Sendername := HREmp."First Name" + ' ' + HRemp."Last Name";

        HREmp.Reset();
        HREmp.SetRange("User ID", Rec."Approver ID");
        if HREmp.Find('-') then Approvername := HREmp."First Name" + ' ' + HRemp."Last Name";
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



    var
        SenderName: text[200];
        ApproverName: text[200];
        HREmp: Record "HR-Employee";
}