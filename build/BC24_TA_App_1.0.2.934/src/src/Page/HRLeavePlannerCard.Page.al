page 50288 "HR Leave Planner Card"
{
    PageType = Card;
    SourceTable = "HR Leave Planner Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Application Code"; Rec."Application Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Application Code field.';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field("Job Tittle"; Rec."Job Tittle")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Job Tittle field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    caption = 'Department Code';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Calendar Code"; Rec."Calendar Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Calendar Code field.';
                }
                field("Date Applied"; Rec."Date Applied")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date Applied field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part(Control1000000002; "Hr Leave Planner Lines")
            {
                SubPageLink = "Application Code" = FIELD("Application Code");
                ApplicationArea = basic;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
            }
            action("&Approvals")
            {
                Caption = '&Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = basic;
                ToolTip = 'Executes the &Approvals action.';
                trigger OnAction()
                begin

                    DocumentType := DocumentType::LeavePlanner;
                    ApprovalEntries.SetRecordFilters(DATABASE::"HR Leave Planner Header", DocumentType, Rec."Application Code");
                    ApprovalEntries.RUN;
                end;
            }
            action("&Send Approval Request")
            {
                Caption = '&Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = basic;
                ToolTip = 'Executes the &Send Approval Request action.';
                trigger OnAction()
                begin


                    if CONFIRM('Send this Leave schedule for Approval?', true) = false then exit;
                    Rec."User ID" := USERID;
                    // ApprovalMgt.SendApprovalRequestFromRecord(VarVariant);
                end;
            }
            action("&Cancel Approval Request")
            {
                Caption = '&Cancel Approval Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = basic;
                ToolTip = 'Executes the &Cancel Approval Request action.';
                trigger OnAction()
                begin
                    //ApprovalMgt.CancelLeavePlannerAppRequest(Rec,TRUE,TRUE);
                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = PrintForm;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Print action.';
            }
        }
    }

    var
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Disciplinary Approvals","Activity Approval","Exit Approval","Medical Claim Approval",Jv,"BackToOffice ","Training Needs",EmpTransfer,LeavePlanner;
        ApprovalEntries: Page "Approval Entries";
}
