Page 50555 "Internal Audits Card"
{
    PageType = Card;
    SourceTable = audits;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(AuditProgramme; Rec."Audit Programme")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Programme field.';
                }
                field(Quarter; Rec.Quarter)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quarter field.';
                }
                field(AuditFromDate; Rec."Audit From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit From Date field.';
                }
                field(AuditToDate; Rec."Audit To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit To Date field.';
                }
                field(LeadersAppointmentDate; Rec."Leaders Appointment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Leaders Appointment Date field.';
                }
                field(MembersAppointmentDate; Rec."Members Appointment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Members Appointment Date field.';
                }
                field(FollowUpToDate; Rec."Follow Up To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Follow Up To Date field.';
                }
                field(ReviewToDate; Rec."Review To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Review To Date field.';
                }
                field(FollowUpFromDate; Rec."Follow Up From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Follow Up From Date field.';
                }
                field(ReviewFromDate; Rec."Review From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Review From Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sequence field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
            }
            part(Control20; Auditors)
            {
                Caption = 'Auditors';
            }
            part(Control21; "Audit Checklists")
            {
                Caption = 'Auditors Checklist';
            }
            part(Control22; "Approver Compliance journal Li")
            {
                Caption = 'Findings';
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Notification")
            {
                ApplicationArea = basic;
                Image = Notes;
                RunObject = page "Internal Audit Notifications";
                RunPageLink = Code = field(Code);
                ToolTip = 'Executes the Notification action.';
            }
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                ApplicationArea = basic;
                ToolTip = 'Executes the Send Approval Request action.';
                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                    varVar: Variant;
                begin
                    //Release the grant for Approval
                    //TESTFIELD("Total Cost");
                    varVar := rec;
                    // IF "Response To fund Opportunity" = TRUE THEN
                    //   IF NOT RecordLinkCheck(Rec) THEN ERROR('You have to attach a link to this document');

                    ApprovalMgt.OnSendDocForApproval(varVar);
                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                ApplicationArea = basic;
                ToolTip = 'Executes the Cancel Approval Request action.';
                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Custom Approvals Codeunit";
                    VaraVar: Variant;
                begin
                    VaraVar := rec;
                    ApprovalMgt.OnCancelDocApprovalRequest(VaraVar);
                end;
            }
        }
    }
}

