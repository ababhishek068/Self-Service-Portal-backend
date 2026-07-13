page 50061 "Direct Voucher "
{
    Caption = 'Direct Voucher GreenCom';
    PageType = Card;
    SourceTable = "Payment Header GreenCom";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("PV No"; Rec."PV No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PV No field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Mode field.';
                }
                field("Paying Bank"; Rec."Paying Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paying Bank field.';
                }
                field("Paying Bank Name"; Rec."Paying Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paying Bank Name field.';
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Description field.';
                }
                field("Total amount"; Rec."Total amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total amount field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }


            }
            part(PartName; "Direct Voucher Lines")
            {
                Caption = 'Direct Voucher Lines';
                SubPageLink = "Document No" = field("PV No");
            }
        }
    }
    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';

                action(postDirect)
                {
                    Caption = 'Post Direct Voucher';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Post Direct Voucher action.';

                    trigger OnAction()
                    begin

                        if Rec.Status <> Rec.Status::Approved then Error('The Document has not been approved');

                        CurrPage.SaveRecord;

                        PostDirectVoucher(Rec."PV No");

                        Rec.Reset;
                        Rec.SetFilter("Pv No", Rec."Pv No");
                        REPORT.Run(50015, true, true, Rec);
                    end;
                }



            }
            separator(Separator13) { }
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin
                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);


                end;
            }
            action(cancellsApproval)
            {
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin
                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                end;
            }
            action(PrintPreview)
            {
                ApplicationArea = Basic;
                Caption = 'Print/Preview';
                Image = PrintAttachment;
                Promoted = true;
                ToolTip = 'Executes the Print/Preview action.';

                trigger OnAction()
                begin

                    Rec.Reset;
                    Rec.SetFilter("Pv No", Rec."Pv No");
                    Report.Run(50015, true, true, Rec);
                    Rec.Reset;
                end;
            }
        }
    }
    procedure PostDirectVoucher(DocNo: Text)
    var
        GenJnlLine: Record "Gen. Journal Line";
        JTemplate: Code[10];
        JBatch: Code[10];
        LineNo: Integer;
        GLEntry: Record "G/L Entry";
        LastEntry: Integer;
    begin


        if Rec.Posted = true then Error('The Document is already Posted!');

        JTemplate := 'GENERAL';
        JBatch := 'DVoucher';

        if JTemplate = '' then Error('Please ensure that the  Template is setup in the cash management setup!!');
        if JBatch = '' then Error('Please ensure that the  Batch is setup in the cash management setup!!');





        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        GenJnlLine.DeleteAll;


        LineNo := LineNo + 1000;
        GenJnlLine.Init;
        GenJnlLine."Journal Template Name" := JTemplate;
        GenJnlLine."Journal Batch Name" := JBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Source Code" := 'PAYMENTJNL';
        GenJnlLine."Posting Date" := Today;
        GenJnlLine."Document Type" := GenJnlLine."document type"::Invoice;
        GenJnlLine."Document No." := Rec."PV No";
        GenJnlLine."External Document No." := Rec."Cheque No";
        GenJnlLine."Account Type" := GenJnlLine."account type"::Vendor;
        GenJnlLine."Account No." := Rec."Vendor No.";
        GenJnlLine.Validate(GenJnlLine."Account No.");
        GenJnlLine.Description := 'Invoices: ' + Rec."Pv No" + ':' + Rec."Vendor No.";
        Rec.CalcFields("Total Amount");
        GenJnlLine.Amount := Rec."Total Amount";
        GenJnlLine.Validate(GenJnlLine.Amount);
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
        GenJnlLine."Bal. Account No." := Rec."Paying Bank";
        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");



        if GenJnlLine.Amount <> 0 then
            GenJnlLine.Insert;

        if GLEntry.FindLast then LastEntry := GLEntry."Entry No.";

        GenJnlLine.Reset;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", JTemplate);
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", JBatch);
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
        Rec.Posted := true;
        Rec."Modified Date" := CurrentDateTime;
        Rec."Posted By" := UserId;
        Rec.Modify;




    end;

}
