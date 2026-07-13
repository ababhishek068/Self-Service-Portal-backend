Page 50373 "Actual Maintenance Card"
{
    PageType = Card;
    SourceTable = "Actual Maintenance ";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(MaintenanceNo; Rec."Maintenance No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Maintenance No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Ambiguous;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(PlannedDate; Rec."Planned Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Planned Date field.';
                }
                field(Dimension1Code; Rec."Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 1 Code field.';
                }
                field(Dimension2Code; Rec."Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 2 Code field.';
                }
                field(PlanNo; Rec."Plan No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Plan No. field.';
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Cost field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
            part(Control12; "Actual Maintenance Lines")
            {
                SubPageLink = "Maintenance No." = field("Maintenance No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                ToolTip = 'Executes the Send Approval Request action.';

                trigger OnAction()
                var
                    vvar: Variant;
                    CustApp: Codeunit "Custom Approvals Codeunit";
                begin
                    vvar := rec;
                    if custapp.CheckApprovalsWorkflowEnabled(vvar) then
                        custapp.OnSendDocForApproval(vvar);
                end;
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Jobs,"Employee Req",Employees,Promotion,Confirmation,"Employee Transfer","Asset Transfer","Transport Req",Overtime,"Training App","Leave App";
                begin

                    DocumentType := Documenttype::"Asset Transfer";
                    //ApprovalEntries.SetRecordFilters(DATABASE::"HR Asset Transfer Header",DocumentType,"No.");
                    //ApprovalEntries.RUN;
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Approval Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                ToolTip = 'Executes the Cancel Approval Request action.';

                trigger OnAction()
                var
                    vvar: Variant;
                    CustApp: Codeunit "Custom Approvals Codeunit";
                begin
                    vvar := rec;
                    if custapp.CheckApprovalsWorkflowEnabled(vvar) then
                        custapp.OnCancelDocApprovalRequest(vvar);
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
                    Rec.SetFilter("Maintenance No.", Rec."Maintenance No.");
                    Report.Run(Report::"Asset Maintenance", true, true, Rec);
                end;
            }
            action(Action13)
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
            action("Confirmation of Work")
            {
                ApplicationArea = Basic;
                Caption = 'Confirmation of Work';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Confirmation of Work";
                RunPageLink = "Gate Pass No." = field("Maintenance No.");
                ToolTip = 'Executes the Confirmation of Work action.';
            }
        }
    }
}

