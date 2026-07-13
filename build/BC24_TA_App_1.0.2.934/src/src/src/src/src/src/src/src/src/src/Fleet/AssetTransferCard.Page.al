Page 50584 "Asset Transfer Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Functions';
    SourceTable = "Asset Transfer";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = FieldEditable;
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(RaisedBy; Rec."Raised By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Raised By field.';
                }
                field(TransferType; Rec."Transfer Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transfer Type field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(AssettoTransfer; Rec."Asset to Transfer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset to Transfer field.';
                }
                field(AssetDescription; Rec."Asset Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Asset Description field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    //Editable = false;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Transferred; Rec.Transferred)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transferred field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
            }
            group(TransferFrom)
            {
                Caption = 'Transfer From';
                Editable = FieldEditable;
                field(FromLocation; Rec."From Location")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the From Location field.';
                }
                field(FromResponsibleEmployee; Rec."From Responsible Employee")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the From Responsible Employee field.';
                }
                field(FromEmployeeName; Rec."From Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ShowCaption = false;
                    Style = AttentionAccent;
                    StyleExpr = true;
                }
                field(FromDimension1Code; Rec."From Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Dimension 1 Code field.';
                }
                field(FromDimension2Code; Rec."From Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Dimension 2 Code field.';
                }
            }
            group(TransferTo)
            {
                Caption = 'Transfer To';
                Editable = FieldEditable;
                field(ToLocation; Rec."To Location")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = false;
                    ToolTip = 'Specifies the value of the To Location field.';
                }
                field(DestinationLocation; Rec."Destination/Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination/Location field.';
                }
                field(ToResponsibleEmployee; Rec."To Responsible Employee")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = false;
                    ToolTip = 'Specifies the value of the To Responsible Employee field.';
                }
                field(ToEmployeeName; Rec."To Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ShowCaption = false;
                }
                field(ToDimension1Code; Rec."To Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Dimension 1 Code field.';
                }
                field(ToDimension2Code; Rec."To Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Dimension 2 Code field.';
                }
            }
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
                        Rec.TestField("Transfer Type");

                        if Rec."Transfer Type" = Rec."transfer type"::External then begin
                            if Rec."Destination/Location" = '' then
                                Error('You must specify Destination/Location where item is going To');
                        end;
                        varr := rec;
                        if ApprovalsMgmt1.CheckApprovalsWorkflowEnabled(Varr) then
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
                        varr := Rec;
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
                    Image = AddAction;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Print action.';

                    trigger OnAction()
                    begin
                        Rec.SetFilter("No.", Rec."No.");
                        Report.Run(Report::"Asset Transfer", true, true, Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls;
        SetControlAppearance;
    end;

    trigger OnInit()
    begin
        UpdateControls;
        UpdateControlsTwo;
    end;

    trigger OnOpenPage()
    begin
        UpdateControls;
    end;

    var
        FieldEditable: Boolean;
        ActionVisible: Boolean;
        ApprovalsMgmt1: Codeunit "Custom Approvals Codeunit";
        Varr: Variant;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        TolocationEditable: Boolean;
        ToResponsibleEmployee: Boolean;

    local procedure UpdateControls()
    begin
        if Rec.Status = Rec.Status::Approved then begin
            FieldEditable := false;
            ActionVisible := false;
        end else begin
            FieldEditable := true;
            ActionVisible := true;
        end;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    local procedure UpdateControlsTwo()
    begin
        if Rec."Transfer Type" = Rec."transfer type"::External then begin
            TolocationEditable := true;
            ToResponsibleEmployee := true;
            CurrPage.Update;
        end else begin
            TolocationEditable := false;
            ToResponsibleEmployee := false;
            CurrPage.Update;
        end;
    end;
}

