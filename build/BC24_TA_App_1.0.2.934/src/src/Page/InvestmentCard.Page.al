Page 50246 "Investment Card"
{
    PageType = Card;
    SourceTable = "Investment Header";
    SourceTableView = where("Investment Category" = const(FDR));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Archived Versions"; Rec."Archived Versions")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Archived Versions field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Investment Start Date"; Rec."Investment Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Start Date field.';
                }
                field("Investment Duration"; Rec."Investment Duration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Duration field.';
                }
                field("Investment End Date"; Rec."Investment End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment End Date field.';
                }
                field("Investment Posting Group"; Rec."Investment Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Posting Group field.';
                }
                field("Investment Company Code"; Rec."Investment Company Code")
                {
                    ApplicationArea = Basic;
                    TableRelation = Customer."Customer Posting Group" where("Customer Posting Group" = const('INV_FDR'));
                    ToolTip = 'Specifies the value of the Investment Company Code field.';
                }
                field("Investment Company Name"; Rec."Investment Company Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Investment Company Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Investment Company Name field.';
                }
                field("Investment Principal"; Rec."Investment Principal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Principal field.';
                }
                field("Investment Rate"; Rec."Investment Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Rate field.';
                }
                field("Withholding Tax Rate"; Rec."Withholding Tax Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Withholding Tax Rate field.';
                }
                field("Investment Withholding Tax"; Rec."Investment Withholding Tax")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Investment Withholding Tax field.';
                }
                field("Investment Rollover Status"; Rec."Investment Rollover Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Investment Rollover Status field.';
                }
                field("Interest Earned"; Rec."Interest Earned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interest Earned field.';
                }
                field("Interest Posted"; Rec."Interest Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interest Posted field.';
                }
                field("No of days elapsed"; Rec."No of days elapsed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No of days elapsed field.';
                }
                field("Principal Posted"; Rec."Principal Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Principal Posted field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            group("Bank Details")
            {
                field("Bank No."; Rec."Bank No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank No. field.';
                }
                field("Bank Description"; Rec."Bank Description")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Bank Description field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control19; MyNotes) { }
            systempart(Control18; Links) { }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Send Approval Request action.';

                trigger OnAction()
                begin
                    if Confirm('Do you want to send this document for approval?', false) then;
                    /*
                      IF ApprovalMgt.SendInvestmentApprovalReq(Rec) THEN;
                      */

                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Approval Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Approval Request action.';

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to cancel approval request?', false) then;
                    /*
                    IF ApprovalMgt.CancelInvestmentAppRequest(Rec,TRUE,TRUE) THEN;
                    */

                end;
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Requisition","Transport Requisition",JV,"Grant Task","Concept Note",Proposal,"Job Approval","Disciplinary Approvals",GRN,Clearence,Donation,Transfer,PayChange,Budget,GL,"Cash Purchase","Leave Reimburse",Appraisal,Inspection,Closeout,"Lab Request",ProposalProjectsAreas,"Leave Carry over","IB Transfer",EmpTransfer,LeavePlanner,HrAssetTransfer,Contract,Project,"Master Record",Investment;
                    ApprovalEntries: Page "Approval Entries";
                begin
                    DocumentType := Documenttype::Investment;
                    ApprovalEntries.SetRecordFilters(Database::"Investment Header", DocumentType, Rec."No.");
                    ApprovalEntries.Run;
                end;
            }
            action(PostInvestment)
            {
                ApplicationArea = Basic;
                Caption = 'Post Investment';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Post Investment action.';
                //RunObject = Report post

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetRange("No.", Rec."No.");
                    Rec.SetRange("Archived Versions", Rec."Archived Versions");
                    Report.Run(39005946, true, false, Rec);
                    Rec.Reset;
                end;
            }
            action("Investment Calculate Interest")
            {
                ApplicationArea = Basic;
                Caption = 'Investment Calculate Interest';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Investment Calculate Interest action.';
                //  RunObject = Report "Investment Calculate Interest";
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetRange("No.", Rec."No.");
                    Rec.SetRange("Archived Versions", Rec."Archived Versions");
                    Report.Run(39005915, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action("Interest Schedule")
            {
                ApplicationArea = Basic;
                Caption = 'Interest Schedule';
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Interest Schedule action.';
                //RunObject = Page UnknownPage70134942;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Investment Category" := Rec."investment category"::FDR;
        Rec."Archived Versions" := 1;
    end;

    trigger OnOpenPage()
    begin
        if (Rec.Status <> Rec.Status::Open) and (Rec.Status <> Rec.Status::"Pending Approval") then CurrPage.Editable(false);
    end;

    var
        GenJnl: Record "Gen. Journal Line";
        InvestmentSetup: Record "Investment Setup";
        Batch: Code[10];
        Template: Code[10];
        //PVLines: Record UnknownRecord70134863; //Payment Lines
        LineNo: Integer;
        InvestmentHeader: Record "Investment Header";

    local procedure Close()
    begin
    end;

    local procedure Rollover()
    begin
    end;

    local procedure PostInterest()
    begin
        LineNo += 1;
        GenJnl.Init;
        GenJnl."Journal Template Name" := Template;
        GenJnl."Journal Batch Name" := Batch;
        GenJnl."Line No." := LineNo;
        GenJnl."Document No." := Rec."No." + '-P' + Format(Rec."Archived Versions");
        GenJnl."Account Type" := GenJnl."account type"::Customer;
        GenJnl.Validate(GenJnl."Account No.", Rec."Investment Company Code");
        GenJnl.Amount := ROUND(Rec."Interest Earned");
        GenJnl.Description := 'Accrued interest for ' + ' ' + Rec."No." + ' ' + Format(Rec."Investment Start Date") + ' ' + Format(Rec."Investment End Date");
        GenJnl."Posting Date" := Today;
        GenJnl.Validate("Shortcut Dimension 1 Code", Rec."Global Dimension 1 Code");
        GenJnl.Validate("Shortcut Dimension 2 Code", Rec."Global Dimension 2 Code");
        GenJnl.Insert(true);

        LineNo += 1;
        GenJnl.Init;
        GenJnl."Journal Template Name" := Template;
        GenJnl."Journal Batch Name" := Batch;
        GenJnl."Line No." := LineNo;
        GenJnl."Document No." := Rec."No." + '-P' + Format(Rec."Archived Versions");
        GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
        GenJnl.Validate(GenJnl."Account No.", InvestmentSetup."Interest G/L Account");
        GenJnl.Amount := -ROUND(Rec."Interest Earned");
        GenJnl.Description := 'Accrued interest for ' + ' ' + Rec."No." + ' ' + Format(Rec."Investment Start Date") + ' ' + Format(Rec."Investment End Date");
        GenJnl."Posting Date" := Today;
        GenJnl.Validate("Shortcut Dimension 1 Code", Rec."Global Dimension 1 Code");
        GenJnl.Validate("Shortcut Dimension 2 Code", Rec."Global Dimension 2 Code");
        GenJnl.Insert;
    end;

    local procedure PostCustomer()
    begin
        LineNo += 1;
        GenJnl.Init;
        GenJnl."Journal Template Name" := Template;
        GenJnl."Journal Batch Name" := Batch;
        GenJnl."Line No." := LineNo;
        GenJnl."Document No." := Rec."No." + '-P' + Format(Rec."Archived Versions");
        GenJnl."Account Type" := GenJnl."account type"::Customer;
        GenJnl.Validate(GenJnl."Account No.", Rec."Investment Company Code");
        GenJnl.Amount := -(Rec."Investment Principal" + ROUND(Rec."Interest Earned"));
        GenJnl.Description := 'Investment maturity ' + ' ' + Rec."No." + ' ' + Format(Rec."Investment Start Date") + ' ' + Format(Rec."Investment End Date");
        GenJnl."Posting Date" := Today;
        GenJnl.Validate("Shortcut Dimension 1 Code", Rec."Global Dimension 1 Code");
        GenJnl.Validate("Shortcut Dimension 2 Code", Rec."Global Dimension 2 Code");
        GenJnl.Insert;
    end;

    local procedure PostBank()
    begin
        LineNo += 1;
        GenJnl.Init;
        GenJnl."Journal Template Name" := Template;
        GenJnl."Journal Batch Name" := Batch;
        GenJnl."Line No." := LineNo;
        GenJnl."Document No." := Rec."No." + '-P' + Format(Rec."Archived Versions");
        GenJnl."Account Type" := GenJnl."account type"::"Bank Account";
        GenJnl.Validate(GenJnl."Account No.", Rec."Bank No.");
        GenJnl.Amount := Rec."Investment Principal" + ROUND(Rec."Interest Earned") - ROUND(Rec."Investment Withholding Tax");
        GenJnl.Description := 'Investment maturity ' + ' ' + Rec."No." + ' ' + Format(Rec."Investment Start Date") + ' ' + Format(Rec."Investment End Date");
        GenJnl."Posting Date" := Today;
        GenJnl.Validate("Shortcut Dimension 1 Code", Rec."Global Dimension 1 Code");
        GenJnl.Validate("Shortcut Dimension 2 Code", Rec."Global Dimension 2 Code");
        GenJnl.Insert;
    end;

    local procedure PostWHT()
    begin
        LineNo += 1;
        GenJnl.Init;
        GenJnl."Journal Template Name" := Template;
        GenJnl."Journal Batch Name" := Batch;
        GenJnl."Line No." := LineNo;
        GenJnl."Document No." := Rec."No." + '-P' + Format(Rec."Archived Versions");
        GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
        GenJnl.Validate(GenJnl."Account No.", InvestmentSetup."Withholding Tax G/L Account");
        GenJnl.Amount := ROUND(Rec."Investment Withholding Tax");
        GenJnl.Description := 'Investment maturity WHT' + ' ' + Rec."No." + ' ' + Format(Rec."Investment Start Date") + ' ' + Format(Rec."Investment End Date");
        GenJnl."Posting Date" := Today;
        GenJnl.Validate("Shortcut Dimension 1 Code", Rec."Global Dimension 1 Code");
        GenJnl.Validate("Shortcut Dimension 2 Code", Rec."Global Dimension 2 Code");
        GenJnl.Insert;
    end;

    local procedure CreateNextInvestment(PrincipleAndInterest: Integer)
    begin
        InvestmentHeader.Reset;
        InvestmentHeader.Init;
        InvestmentHeader.TransferFields(Rec);
        InvestmentHeader.Validate("Investment Start Date", Today);
        InvestmentHeader."Document Date" := Today;
        if PrincipleAndInterest = 0 then
            InvestmentHeader."Investment Principal" := Rec."Investment Principal"
        else
            if PrincipleAndInterest = 1 then
                InvestmentHeader."Investment Principal" := Rec."Investment Principal" + ROUND(Rec."Interest Earned") - ROUND(Rec."Investment Withholding Tax");
        InvestmentHeader."Interest Earned" := 0;
        InvestmentHeader."Investment Withholding Tax" := 0;
        InvestmentHeader.Status := InvestmentHeader.Status::"Pending Approval";
        InvestmentHeader."Investment Rollover Status" := InvestmentHeader."investment rollover status"::" ";
        InvestmentHeader."No of days elapsed" := 0;
        InvestmentHeader."Principal Posted" := false;
        InvestmentHeader.Posted := false;
        InvestmentHeader."Date Posted" := 0D;
        InvestmentHeader."Time Posted" := 0T;
        InvestmentHeader."Posted By" := '';
        InvestmentHeader."Archived Versions" := Rec."Archived Versions" + 1;
        InvestmentHeader."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
        InvestmentHeader."Global Dimension 2 Code" := Rec."Global Dimension 2 Code";
        InvestmentHeader."Dimension Set ID" := Rec."Dimension Set ID";
        InvestmentHeader.Insert(true);
    end;
}

