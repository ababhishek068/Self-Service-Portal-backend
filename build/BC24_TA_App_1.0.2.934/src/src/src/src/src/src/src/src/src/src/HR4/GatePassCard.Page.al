Page 51244 "Gate Pass Card"
{
    PageType = Card;
    SourceTable = "Gate Pass";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(EmployeeNo; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field(EmployeeName; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(Station; Rec.Station)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Station field.';
                }
                field("Station Name"; Rec."Station Name")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Station Name field.';
                }
                field(Depatment; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field(DateOut; Rec."Date Out")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Out field.';
                }
                field(TimeOut; Rec."Time Out")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Out field.';
                }
                field(AssetTransferNo; Rec."Asset Transfer No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Transfer No field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(AssetDescription; Rec."Asset Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Description field.';
                }
                field(AssetFromLocation; Rec."Asset From Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset From Location field.';
                }
                field(AssetToLocation; Rec."Asset To Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset To Location field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(ToBeReturned; Rec."To Be Returned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Be Returned field.';
                }
            }
            field(Comment; Rec.Comment)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Comment field.';
            }
        }
        area(factboxes)
        {
            systempart(Control13; Outlook) { }
        }
    }

    actions
    {
        area(processing)
        {
            group(ApprovalRequest)
            {
                Caption = 'Approval Request';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send Approval Request action.';

                    trigger OnAction()
                    begin
                        Rec.TestField("To Be Returned");
                        Rec.TestField(Comment);
                        varr := rec;
                        if ApprovalsMgmt1.CheckApprovalsWorkflowEnabled(varr) then
                            ApprovalsMgmt1.OnSendDocForApproval(varr);
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Request action.';

                    trigger OnAction()
                    begin
                        ApprovalsMgmt1.OnCancelDocApprovalRequest(varr);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category9;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId)
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Approve action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Reject action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    ToolTip = 'Executes the Delegate action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Print)
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Print action.';

                    trigger OnAction()
                    begin
                        Rec.SetFilter(No, Rec.No);
                        Report.Run(Report::"Gate Pass Report", true, true, Rec);
                    end;
                }
            }
        }
    }

    var
        ApprovalsMgmt1: Codeunit "Custom Approvals Codeunit";
        Varr: Variant;
        OpenApprovalEntriesExistForCurrUser: Boolean;
}

