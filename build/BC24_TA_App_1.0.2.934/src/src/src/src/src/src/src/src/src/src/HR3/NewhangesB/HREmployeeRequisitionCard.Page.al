Page 51317 "HR Employee Requisition Card"
{
    DeleteAllowed = true;
    InsertAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Functions,Job';
    SourceTable = "HR Employee Requisitions";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(RequisitionNo; Rec."Requisition No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition No. field.';
                }
                field(RequisitionDate; Rec."Requisition Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Requisition Date field.';
                }

                field(Requestor; Rec.Requestor)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Requestor field.';
                }
                field(JobID; Rec."Job ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field(JobDescription; Rec."Job Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
                field(ReasonForRequest; Rec."Reason For Request")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reason For Request field.';
                }
                field(TypeofContractRequired; Rec."Type of Contract Required")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type of Contract Required field.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Priority field.';
                }
                field(Positions; Rec.Positions)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Positions field.';
                }
                field("Vacant Positions";"Vacant Positions"){}
                field(RequiredPositions; Rec."Required Positions")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Required Positions field.';
                }

                field("Opening Date"; Rec."Opening Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Opening Date field.';
                }

                // field("Recruitment Duration"; "Recruitment Duration")
                // {
                //     ApplicationArea = all;
                // }
                field("Closing Date"; Rec."Closing Date")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Closing Date field.';
                }
                field(RequisitionType; Rec."Requisition Type")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Requisition Type field.';
                }
                field(Advertised; Rec.Advertised)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Advertised field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            group(AdditionalInformation)
            {
                Caption = 'Additional Information';
            }
        }
        area(factboxes)
        {
            systempart(Control1102755020; Outlook) { }
        }
    }

    actions
    {
        area(processing)
        {

            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RECORDID);
                end;
            }

            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Enabled = true;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = basic;
                ToolTip = 'Executes the Send Approval Request action.';

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
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Enabled = true;
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = basic;
                ToolTip = 'Executes the Cancel Approval Request action.';

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
        }
    }

}

