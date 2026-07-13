page 50575 "ICT Requisition Card"
{
    PageType = card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ICT General Requisition Header";
    SourceTableView = where("Resolution Status" = filter(<> Open));
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Requisition Category"; Rec."Requisition Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requisition Category field.';

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    caption = 'Station';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Station field.';

                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    caption = 'Department';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department field.';

                }

                field("Urgency Priority"; Rec."Urgency Priority")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Urgency Priority field.';

                }
                field("Required Date"; Rec."Required Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Required Date field.';

                }
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Requestor Name field.';
                }
                field("Resolution Status"; Rec."Resolution Status")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Resolution Status field.';

                }
                field(Assignee; Rec.Assignee)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assignee field.';
                }
                field("Assignee Name"; Rec."Assignee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assignee Name field.';
                }
                field("General Description"; Rec."General Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the General Description field.';

                }
                field("Resolution Remarks"; Rec."Resolution Remarks")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Resolution Remarks field.';

                }
                field("User Closing Remarks"; Rec."User Closing Remarks")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the User Closing Remarks field.';
                }
                field("Date User Confirmed"; Rec."Date User Confirmed")
                {
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Date User Confirmed field.';
                }
            }
            // part(Lines; "ICT Requisition Lines")
            // {
            //     ApplicationArea = basic;
            //     SubPageLink = No = field(No);

            // }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(54100),
                              "No." = FIELD(No);
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action("Print Requisition Solution")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Print Requisition Solution action.';

                trigger OnAction()
                var
                    ICTReq: Record "ICT General Requisition Header";
                begin
                    ICTReq.reset;
                    ICTReq.Setfilter(ICTReq.No, Rec.No);
                    if ICTReq.find('-') then
                        report.run(50619, true, true, ICTReq);

                end;
            }
            action(Close)
            {
                ApplicationArea = Basic;
                Caption = 'Resolved';
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ResolvedVisvible;
                ToolTip = 'Executes the Resolved action.';

                trigger OnAction()
                var
                    smtp: Codeunit HRWebportal;
                    hremp: Record "HR-Employee";
                begin
                    if Rec.Assignee = '' then Error('Kindly assign the ICT Officer');
                    if Confirm('Do you want to close this requisition?', false) = true then begin

                        Rec."Resolution Status" := Rec."Resolution Status"::"Resolved Waiting User Confirmation";
                        Rec."Date Resolved" := CurrentDateTime;
                        Rec.modify();
                        if hremp.Get(Rec.Assignee) then begin
                            smtp.SendEmail(hremp."Company E-Mail", 'ICT REQUEST ASSIGNED', 'You have been assigned task no ' + Rec.No + '.Requested by' + Rec."Requestor Name" + '. Details: ' + Rec."General Description" + ' .Kindly login and act upon it.')
                        end;
                    end;

                end;
            }
            action(Escslate)
            {
                ApplicationArea = Basic;
                Caption = 'Escalate';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = EscalateVisvible;
                ToolTip = 'Executes the Escalate action.';
                trigger OnAction()
                begin
                    if Rec."Resolution Status" = Rec."Resolution Status"::Submitted then begin
                        if Confirm('Do you want to escalate this requisition?', false) = true then begin
                            Rec."Resolution Status" := Rec."Resolution Status"::InProgress;
                            Rec."Date Escalated" := Today;
                            Rec.modify();
                        end;
                    end;
                end;
            }
            action(UserConf)
            {
                ApplicationArea = Basic;
                Caption = 'User Confirmation';
                Image = UserInterface;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ConfirmVisvible;
                ToolTip = 'Executes the User Confirmation action.';
                trigger OnAction()
                begin
                    if Rec."Resolution Status" = Rec."Resolution Status"::"Resolved Waiting User Confirmation" then begin
                        if Confirm('Do you want to confirm resolution of this requisition?', false) = true then begin
                            Rec."Resolution Status" := Rec."Resolution Status"::Closed;
                            Rec.modify();
                        end;
                    end;
                end;
            }
        }
        // area(Processing)
        // {

        //     group("F&unctions")
        //     {
        //         Caption = 'F&unctions';
        //         action(Approvals)
        //         {
        //             Caption = 'Approvals';
        //             Image = Approvals;
        //             ApplicationArea = all;
        //             trigger OnAction()
        //             var
        //                 ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        //             begin
        //                 ApprovalsMgmt.OpenApprovalEntriesPage(RecordId)
        //             end;
        //         }
        //         separator(Separator1102755018)
        //         {
        //         }
        //         action("Send Approval Request")
        //         {
        //             Caption = 'Send Approval Request';
        //             Image = SendApprovalRequest;
        //             ApplicationArea = basic;
        //             trigger OnAction()
        //             var
        //                 ApprovalMgt: Codeunit "Custom Approvals Codeunit";
        //                 varVar: Variant;
        //             begin
        //                 varVar := rec;

        //                 ApprovalMgt.OnSendDocForApproval(varVar);
        //             end;
        //         }
        //         action("Cancel Approval Request")
        //         {
        //             Caption = 'Cancel Approval Request';
        //             ApplicationArea = basic;
        //             trigger OnAction()
        //             var
        //                 ApprovalMgt: Codeunit "Custom Approvals Codeunit";
        //                 VaraVar: Variant;
        //             begin
        //                 VaraVar := rec;
        //                 ApprovalMgt.OnCancelDocApprovalRequest(VaraVar);
        //             end;
        //         }
        //     }
        // }
    }
    trigger OnOpenPage()
    begin
        if Rec."ICT. Dep. Code" = '' then begin
            HRSetup.Get();
            HRSetup.TestField("ICT Dep. Code");
            Rec."ICT. Dep. Code" := HRSetup."ICT Dep. Code";
            Rec.Modify();
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        EscalateVisvible := false;
        ResolvedVisvible := false;
        ConfirmVisvible := false;
        if Rec."Resolution Status" = Rec."Resolution Status"::Submitted then EscalateVisvible := true;
        if Rec."Resolution Status" = Rec."Resolution Status"::"Resolved Waiting User Confirmation" then ConfirmVisvible := true;
        if ((Rec."Resolution Status" = Rec."Resolution Status"::Submitted) or (Rec."Resolution Status" = Rec."Resolution Status"::InProgress)) then ResolvedVisvible := true;
    end;

    var
        HRSetup: Record "HR Setup";
        EscalateVisvible: Boolean;
        ResolvedVisvible: Boolean;
        ConfirmVisvible: Boolean;
}