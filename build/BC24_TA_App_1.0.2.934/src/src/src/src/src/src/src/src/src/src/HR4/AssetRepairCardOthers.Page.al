Page 51247 "Asset Repair Card  Others"
{
    PageType = Card;
    SourceTable = "Asset Repair Header";
    SourceTableView = where("Asset Type" = filter("Other Assets"),
                            Status = filter(<> Approved));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(RequestNo; Rec."Request No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Request No. field.';
                }
                field(AssetType; Rec."Asset Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Type field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(RequestedBy; Rec."Requested By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = AttentionAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
                field(RequestDate; Rec."Request Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = AttentionAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Request Date field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Total Cost field.';
                }
                field(TotalAssets; Rec."Total Assets")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Assets field.';
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part(Control12; "Asset Repair Lines")
            {
                SubPageLink = "Request No." = field("Request No."),
                              "Asset Type" = field("Asset Type");
                UpdatePropagation = Both;
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
                        varr := Rec;
                        if ApprovalsMgmt1.CheckCustomerApprovalsWorkflowEnabled(varr) then
                            ApprovalsMgmt1.OnSendCustomerForApproval(varr);
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
                        varr := rec;
                        ApprovalsMgmt1.CanCancelApprovalForRecord(varr)
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
                action("Confirmation Of Work Done")
                {
                    ApplicationArea = Basic;
                    Image = AbsenceCategory;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Confirmation of Work";
                    RunPageLink = "Gate Pass No." = field("Request No.");
                    ToolTip = 'Executes the Confirmation Of Work Done action.';
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
                        Rec.SetFilter("Request No.", Rec."Request No.");
                        Report.Run(Report::"Asset Repair Header Report", true, true, Rec);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Asset Type" := Rec."asset type"::"Other Assets";
    end;

    var
        ApprovalsMgmt1: Codeunit "Approvals Mgmt.";
        Varr: Variant;
}

