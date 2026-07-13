Page 50804 "Disposal Plan"
{
    SourceTable = "Disposal Plan Table Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(No; Rec."No.")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the No. field.';
            }
            field(DisposalYear; Rec."Disposal Year")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Disposal Year field.';
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = Basic;
                Caption = 'Justification';
                ToolTip = 'Specifies the value of the Justification field.';
            }
            field(DisposalDescription; Rec."Disposal Description")
            {
                ApplicationArea = Basic;
                Visible = false;
                ToolTip = 'Specifies the value of the Disposal Description field.';
            }
            field(Date; Rec.Date)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Date field.';
            }
            field(PlannedDate; Rec."Planned Date")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Planned Date field.';
            }
            field("Disposal Status"; Rec."Disposal Status")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Disposal Status field.';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Status field.';

            }
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';

            }
            field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';

            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';

            }
            field(ResponsibilityCenter; Rec."Responsibility Center")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Responsibility Center field.';
            }
            part("Disposal Plan Lines"; "Disposal Plan Table Line")
            {
                SubPageLink = "Ref. No." = field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send For Approval")
            {
                ApplicationArea = Basic;
                Caption = 'Send For Approval';
                ToolTip = 'Executes the Send For Approval action.';

                trigger OnAction()
                begin
                    varr := Rec;
                    if ApprovalsMgmt.CheckApprovalsWorkflowEnabled(varr) then
                        ApprovalsMgmt.OnSendDocForApproval(varr);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Approval Request';
                ToolTip = 'Executes the Cancel Approval Request action.';

                trigger OnAction()
                begin
                    varr := Rec;
                    ApprovalsMgmt.OnCancelDocApprovalRequest(varr);
                end;
            }
            action(Action9)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    DocType := Doctype::Disposal;
                    ApprovalEntries.SetRecordFilters(Database::"Disposal Plan Table Header", DocType, Rec."No.");
                    ApprovalEntries.Run;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."Ref No");
                    Report.Run(Report::"Disposal Plan Reports", true, true, Rec);
                    Rec.Reset;
                end;
            }
        }
    }

    var
        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
        Varr: Variant;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imp,Requisition,ImpSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Requisition","Transport Requisition",JV,"Grant Task","Concept Note",Disposal,"Job Approval","Disciplinary Approvals",GRN,Clearence,Donation,Transfer,PayChange,Budget,GL,"Cash Purchase","Leave Reimburse",Appraisal,Inspection,Closeout,"Lab Request",ProposalProjectsAreas,"Leave Carry over","IB Transfer",EmpTransfer,LeavePlanner,HrAssetTransfer,Contract,Project,MR,Inves,PB,Prom,Ind,Conf,BSC,OT,Jobsucc,SuccDetails,Qualified,Disc;
}

