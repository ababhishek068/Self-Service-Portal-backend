Page 51240 "Asset Repair Card Vehicles"
{
    // //test

    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Asset Repair Header";
    //SourceTableView = where("Asset Type" = const(Vehicles));
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
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
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
            systempart(Control25; Links)
            {
                Visible = true;
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
                    var
                        vvar: Variant;
                        CApp: Codeunit "Custom Approvals Codeunit";
                    begin
                        Rec.TestField("Responsibility Center");
                        Rec.CalcFields("Total Assets");
                        if Rec."Total Assets" < 1 then
                            Error('Asset Repair lines must have avalue');
                        MastHave;
                        vvar := Rec;
                        if capp.CheckApprovalsWorkflowEnabled(vvar) then
                            capp.OnSendDocForApproval(vvar);
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
                    var
                        vvar: Variant;
                        CApp: Codeunit "Custom Approvals Codeunit";
                    begin
                        vvar := Rec;
                        if capp.CheckApprovalsWorkflowEnabled(vvar) then
                            capp.OnCancelDocApprovalRequest(vvar);
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
                        Rec.SetFilter("Request No.", Rec."Request No.");
                        Report.Run(Report::"Asset Repair Header Report", true, true, Rec);
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Asset Type" := Rec."asset type"::Vehicles;
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        AssetRepairLines: Record "Asset Repair Lines";

    local procedure MastHave()
    begin
        AssetRepairLines.Reset;
        AssetRepairLines.SetRange(AssetRepairLines."Asset Type", AssetRepairLines."asset type"::Vehicles);
        AssetRepairLines.SetRange(AssetRepairLines."Request No.", Rec."Request No.");
        if AssetRepairLines.Find('-') then begin
            repeat
            //AssetRepairLines.TestField("Registartion No");
            //AssetRepairLines.TestField("Service Provider");
            //AssetRepairLines.TestField("Type of Maitenance");
            //AssetRepairLines.TestField("Current Mileage");
            //AssetRepairLines.TestField("Service Mileage");
            until AssetRepairLines.Next = 0;
        end;
    end;
}

